using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Diagnostics;
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
    private bool _hasReports;

    public ObservableCollection<ReportItemViewModel> Reports
    {
        get => _reports;
        private set
        {
            if (_reports != value)
            {
                _reports = value;
                OnPropertyChanged(nameof(Reports));
                HasReports = _reports.Any();
            }
        }
    }

    public bool HasReports
    {
        get => _hasReports;
        private set
        {
            if (_hasReports != value)
            {
                _hasReports = value;
                OnPropertyChanged(nameof(HasReports));
            }
        }
    }

    public bool IsLoading
    {
        get => _isLoading;
        private set
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
    public ICommand DeleteReportCommand { get; }

    public ReportBrowserViewModel(IReportCacheService reportCacheService)
    {
        _reportCacheService = reportCacheService;
        _reports = new ObservableCollection<ReportItemViewModel>();

        RefreshCommand = new Command(async () => await LoadReportsAsync());
        OpenReportCommand = new Command<string>(async (reportId) => await OpenReportAsync(reportId));
        DeleteReportCommand = new Command<string>(async (reportId) => await DeleteReportAsync(reportId));

        InitializeReports();
    }

    private async void InitializeReports()
    {
        await LoadReportsAsync();
    }

    private async Task LoadReportsAsync()
    {
        if (!await _loadingLock.WaitAsync(0)) return;

        try
        {
            IsLoading = true;
            var tempReports = new List<ReportItemViewModel>();
            var allReports = await _reportCacheService.GetAllReportsAsync();

            foreach (var report in allReports)
                tempReports.Add(new ReportItemViewModel
                {
                    ReportId = report.Metadata.ReportId,
                    CustomerName = report.CustomerInfo.OwnerDetails?.Name ?? "Unknown",
                    Location = report.DeviceInfo.Location?.OnSiteLocation ?? "Unknown",
                    DateCreated = report.Metadata.CreatedDate,
                    LastModified = report.Metadata.LastModifiedDate
                });


            // Update the observable collection
            Reports.Clear();
            foreach (var report in tempReports.OrderByDescending(r => r.LastModified)) Reports.Add(report);

            HasReports = Reports.Any();
        }
        catch (Exception ex)
        {
            Debug.WriteLine($"Error loading reports: {ex.Message}");
            await Shell.Current.DisplayAlert("Error", "Unable to load reports. Please try again later.", "OK");
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

        var report = await _reportCacheService.LoadReportAsync(reportId);
        if (report == null) return;

        var viewModel = new CustomerInfoViewModel(report);
        await Shell.Current.GoToAsync("CustomerInfo", new Dictionary<string, object>
        {
            ["ViewModel"] = viewModel
        });
    }

    private async Task DeleteReportAsync(string reportId)
    {
        if (!await Shell.Current.DisplayAlert(
                "Delete Report",
                "Are you sure you want to delete this report?",
                "Delete",
                "Cancel"))
            return;

        await _reportCacheService.DeleteReportAsync(reportId);
        await LoadReportsAsync();
    }

    public event PropertyChangedEventHandler? PropertyChanged;

    protected virtual void OnPropertyChanged([CallerMemberName] string? propertyName = null)
    {
        PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
    }
}