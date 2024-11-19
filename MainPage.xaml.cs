using ABFReportEditor.ViewModels;
using ABFReportEditor.Views;

namespace ABFReportEditor;

public partial class MainPage : ContentPage
{
    public MainPage()
    {
        InitializeComponent();
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

    private void OnCreatePdfClicked(object? sender, EventArgs e)
    {
        // TODO: Implement creat pdf view / workflow
        throw new NotImplementedException();
    }
}
