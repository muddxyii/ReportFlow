using ReportFlow.Interfaces;
using ReportFlow.Models;
using ReportFlow.Util;
using ReportFlow.ViewModels.InfoViewModels;
using ReportFlow.ViewModels.ReportViewModels;

namespace ReportFlow;

public partial class MainPage : ContentPage
{
    private bool _isNavigating;

    public MainPage()
    {
        InitializeComponent();

#if ANDROID
        System.Diagnostics.Debug.WriteLine("Checking for PDF intent...");
    if (Platform.CurrentActivity?.Intent?.Data != null)
    {
        System.Diagnostics.Debug.WriteLine($"Found intent data: {Platform.CurrentActivity.Intent.Data}");
        using (var data = Platform.CurrentActivity.Intent.Data)
        {
            var uri = new Uri(data.ToString());
            HandlePdfIntent(uri);
        }
    }
#endif
    }

    // Loads File Stream (Assumes File Is A Pdf)
    private async void LoadFileStream(Stream? fileStream)
    {
        try
        {
            if (fileStream == null)
            {
                await DisplayAlert("Error", "Invalid file stream", "OK");
                return;
            }

            // Extract Old Form Data
            var oldFormData = PdfUtils.ExtractPdfFormData(fileStream);
            var report = new ReportData(oldFormData, true);

            // Load Next Model
            var viewModel = new CustomerInfoViewModel(report);
            await Shell.Current.GoToAsync("CustomerInfo", new Dictionary<string, object>
            {
                ["ViewModel"] = viewModel
            });
        }
        catch (Exception ex)
        {
            await DisplayAlert("Error", ex.Message, "OK");
        }
    }

    #region Open Pdf Button

    private async void OnOpenPdfClicked(object sender, EventArgs e)
    {
        try
        {
            // Select File Options
            var options = new PickOptions
            {
                FileTypes = new FilePickerFileType(new Dictionary<DevicePlatform, IEnumerable<string>>
                {
                    { DevicePlatform.Android, ["application/pdf"] },
                    { DevicePlatform.iOS, ["public.pdf"] },
                    { DevicePlatform.WinUI, [".pdf"] }
                })
            };

            // Load File Result
            var result = await FilePicker.PickAsync(options);
            if (result == null)
                throw new FileNotFoundException("No file selected.");

            // Load File Stream
            LoadFileStream(await result.OpenReadAsync());
        }
        catch (Exception ex)
        {
            await DisplayAlert("Error", ex.Message, "OK");
        }
    }

    #endregion

    #region Create Pdf Button

    private async void OnCreateReportClicked(object? sender, EventArgs e)
    {
        try
        {
            // Select Pdf Template
            var pdfTemplate = "ReportFlow.Resources.PdfTemplates.Abf-Fillable-12-24.pdf";

            // Load Pdf Stream
            await using var resourceStream = GetType().Assembly.GetManifestResourceStream(pdfTemplate);
            if (resourceStream == null)
                throw new FileNotFoundException("Template not found.");

            // Load File Stream
            LoadFileStream(resourceStream);
        }
        catch (Exception ex)
        {
            await DisplayAlert("Error", ex.Message, "OK");
        }
    }

    #endregion

    #region Browse Reports Button

    private async void OnBrowseReportsClicked(object? sender, EventArgs e)
    {
        if (_isNavigating) return;
        _isNavigating = true;

        try
        {
            var reportCacheService = IPlatformApplication.Current?.Services.GetService<IReportCacheService>();
            if (reportCacheService == null)
            {
                await DisplayAlert("Error", "Report service not available", "OK");
                return;
            }

            // Navigate to the browse page with the data
            await Shell.Current.GoToAsync("ReportBrowser", new Dictionary<string, object>
            {
                ["ViewModel"] = new ReportBrowserViewModel(reportCacheService)
            });
        }
        catch (Exception ex)
        {
            await DisplayAlert("Error", ex.Message, "OK");
        }
        finally
        {
            _isNavigating = false;
        }
    }

    #endregion

    #region Settings Button

    private async void OnSettingsClicked(object? sender, EventArgs e)
    {
        if (_isNavigating) return;
        _isNavigating = true;

        try
        {
            await Shell.Current.GoToAsync("SettingsPage");
        }
        finally
        {
            _isNavigating = false;
        }
    }

    #endregion

#if ANDROID
    public async void HandlePdfIntent(Uri pdfUri)
    {
        try
        {
            System.Diagnostics.Debug.WriteLine("[MainPage] HandlePdfIntent called with URI: " + pdfUri);
            
            // Get Intent File Stream
            var pdfIntentHelper = IPlatformApplication.Current?.Services.GetService<IPdfIntentHelper>();
            var pdfStream = await pdfIntentHelper.GetPdfStream(pdfUri);
            
            if (pdfStream == null)
                throw new FileNotFoundException("File not found.");
            
            // Load File Stream
            LoadFileStream(pdfStream);
        }
        catch (Exception ex)
        {
            await DisplayAlert("Error", ex.Message, "OK");
        }
    }
#endif
}