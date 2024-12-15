using ReportFlow.Interfaces;
using ReportFlow.ViewModels.InfoViewModels;

namespace ReportFlow;

public partial class MainPage : ContentPage
{
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

    public async void HandlePdfIntent(Uri pdfUri)
    {
        try
        {
            var pdfIntentHelper = IPlatformApplication.Current?.Services.GetService<IPdfIntentHelper>();
            var pdfBytes = await pdfIntentHelper.GetPdfBytes(pdfUri);
            if (pdfBytes != null)
            {
                var viewModel = new CustomerInfoViewModel();
                viewModel.LoadPdfData(pdfBytes);
                await Shell.Current.GoToAsync("CustomerInfo", new Dictionary<string, object>
                {
                    ["ViewModel"] = viewModel
                });
            }
            else
            {
                await DisplayAlert("Error", "Could not read PDF file", "OK");
            }
        }
        catch (Exception ex)
        {
            await DisplayAlert("Error", ex.Message, "OK");
        }
    }

    private async void OnOpenPdfClicked(object sender, EventArgs e)
    {
        try
        {
            var options = new PickOptions
            {
                FileTypes = new FilePickerFileType(new Dictionary<DevicePlatform, IEnumerable<string>>
                {
                    { DevicePlatform.Android, ["application/pdf"] },
                    { DevicePlatform.iOS, ["public.pdf"] },
                    { DevicePlatform.WinUI, [".pdf"] }
                })
            };

            var result = await FilePicker.PickAsync(options);
            if (result != null)
            {
                if (result.FileName.EndsWith("pdf", StringComparison.OrdinalIgnoreCase))
                {
                    var viewModel = new CustomerInfoViewModel();
                    viewModel.LoadPdfData(File.ReadAllBytes(result.FullPath));
                    await Shell.Current.GoToAsync("CustomerInfo", new Dictionary<string, object>
                    {
                        ["ViewModel"] = viewModel
                    });
                }
                else
                {
                    await DisplayAlert("Error", "Please select a PDF file", "OK");
                }
            }
        }
        catch (Exception ex)
        {
            await DisplayAlert("Error", ex.Message, "OK");
        }
    }

    private async void OnCreatePdfClicked(object? sender, EventArgs e)
    {
        await Application.Current.MainPage.DisplayAlert(
            "Not Implemented",
            $"This feature has not been implemented.",
            "OK"
        );
    }
}