using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Runtime.CompilerServices;
using System.Windows.Input;
using ReportFlow.Interfaces;
using ReportFlow.ViewModels.InfoViewModels;

namespace ReportFlow.ViewModels.ReportViewModels;

public class ReportBrowserViewModel : INotifyPropertyChanged
{
    private readonly IReportCacheService _reportCacheService;
    private ObservableCollection<ReportItemViewModel> _reports;
    private bool _isLoading;
    private readonly SemaphoreSlim _loadingLock = new(1, 1);

    public event PropertyChangedEventHandler? PropertyChanged;

    public ObservableCollection<ReportItemViewModel> Reports
    {
        get => _reports;
        set
        {
            if (_reports != value)
            {
                _reports = value;
                OnPropertyChanged(nameof(Reports));
            }
        }
    }

    public bool IsLoading
    {
        get => _isLoading;
        set
        {
            if (_isLoading != value)
            {
                _isLoading = value;
                OnPropertyChanged(nameof(IsLoading));
            }
        }
    }

    public ICommand RefreshCommand { get; }
    public ICommand OpenReportCommand { get; }

    public ReportBrowserViewModel(IReportCacheService reportCacheService)
    {
        _reportCacheService = reportCacheService;
        _reports = new ObservableCollection<ReportItemViewModel>();
        
        RefreshCommand = new Command(async () => await LoadReportsAsync());
        OpenReportCommand = new Command<string>(async (reportId) => await OpenReportAsync(reportId));
        
        // Load reports when constructed
        MainThread.BeginInvokeOnMainThread(async () => await LoadReportsAsync());
    }

    protected virtual void OnPropertyChanged([CallerMemberName] string? propertyName = null)
    {
        PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
    }

    private async Task LoadReportsAsync()
    {
        if (!await _loadingLock.WaitAsync(0))
            return;
        
        try
        {
            IsLoading = true;
            Reports.Clear();

            var reportIds = (await _reportCacheService.GetSavedReportIdsAsync()).Distinct();
            foreach (var reportId in reportIds)
            {
                if (reportId == null) continue;
                
                var reportData = await _reportCacheService.LoadReportDataAsync(reportId);
                if (reportData == null) continue;

                Reports.Add(new ReportItemViewModel
                {
                    ReportId = reportId,
                    CustomerName = reportData.GetValueOrDefault("FacilityOwner", "Unknown"),
                    Address = reportData.GetValueOrDefault("AssemblyAddress", "Unknown"),
                    DateCreated = DateTime.TryParse(reportData.GetValueOrDefault("DateCreated"), out var date) 
                        ? date 
                        : DateTime.MinValue
                });
            }
        }
        finally
        {
            IsLoading = false;
            _loadingLock.Release();
        }
    }

    private async Task OpenReportAsync(string? reportId)
    {
        if (string.IsNullOrEmpty(reportId)) return;
 
        var reportData = await _reportCacheService.LoadReportDataAsync(reportId);
        if (reportData == null) return;
        
        reportData["report_id"] = reportId;

        var viewModel = new CustomerInfoViewModel(reportData);
        await Shell.Current.GoToAsync("CustomerInfo", new Dictionary<string, object>
        {
            ["ViewModel"] = viewModel
        });
    }
}