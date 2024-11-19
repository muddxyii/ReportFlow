namespace ABFReportEditor.Views;

public partial class CustomerInfoPage : ContentPage
{
    public CustomerInfoPage()
    {
        InitializeComponent();
    }

    private async void OnNextClicked(object? sender, EventArgs e)
    {
        await Navigation.PushAsync(new DeviceInfoPage());
    }
}