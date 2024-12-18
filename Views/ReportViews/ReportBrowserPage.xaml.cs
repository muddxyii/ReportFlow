using ReportFlow.Interfaces;
using ReportFlow.ViewModels.ReportViewModels;

namespace ReportFlow.Views.ReportViews;

public partial class ReportBrowserPage : ContentPage
{
    public ReportBrowserPage()
    {
        InitializeComponent();
        
        var reportCacheService = IPlatformApplication.Current?.Services.GetService<IReportCacheService>();
        if (reportCacheService != null)
        {
            BindingContext = new ReportBrowserViewModel(reportCacheService);
        }
    }
}