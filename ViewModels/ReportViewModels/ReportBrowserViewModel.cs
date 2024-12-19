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

    public event PropertyChangedEventHandler? PropertyChanged;

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
        
        // Initialize reports
        InitializeReports();
    }
    
    private async void InitializeReports()
    {
        await LoadReportsAsync();
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
        var tempReports = new List<ReportItemViewModel>();

        var allMetadata = await _reportCacheService.GetAllReportMetadataAsync();
        
        foreach (var metadata in allMetadata)
        {
            // Skip invalid metadata
            if (metadata == null || string.IsNullOrWhiteSpace(metadata.ReportId))
                continue;

            try
            {
                var reportData = await _reportCacheService.LoadReportDataAsync(metadata.ReportId);
                if (reportData == null) continue;

                tempReports.Add(new ReportItemViewModel
                {
                    ReportId = metadata.ReportId,
                    CustomerName = reportData.GetValueOrDefault("FacilityOwner", "Unknown"),
                    Address = reportData.GetValueOrDefault("AssemblyAddress", "Unknown"),
                    DateCreated = metadata.CreatedDate,
                    LastModified = metadata.LastModifiedDate
                });
            }
            catch (Exception ex)
            {
                Debug.WriteLine($"Error loading report {metadata.ReportId}: {ex.Message}");
                // Continue to next report instead of breaking the entire loop
                continue;
            }
        }

        // Sort by last modified date descending
        var sortedReports = tempReports.OrderByDescending(r => r.LastModified).ToList();
        
        // Update the observable collection
        Reports.Clear();
        foreach (var report in sortedReports)
        {
            Reports.Add(report);
        }
        
        HasReports = Reports.Any();
    }
    catch (Exception ex)
    {
        Debug.WriteLine($"Error loading reports: {ex.Message}");
        await Shell.Current.DisplayAlert(
            "Error",
            "Unable to load reports. Please try again later.",
            "OK");
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
    
    private async Task DeleteReportAsync(string reportId)
    {
        var shouldDelete = await Shell.Current.DisplayAlert(
            "Delete Report",
            "Are you sure you want to delete this report?",
            "Delete",
            "Cancel");

        if (!shouldDelete) return;

        await _reportCacheService.DeleteReportDataAsync(reportId);
        await LoadReportsAsync();
    }
}