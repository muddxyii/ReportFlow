namespace ReportFlow.Views.InfoViews;

[QueryProperty(nameof(ViewModel), "ViewModel")]
public partial class DeviceInfoPage
{
    public DeviceInfoPage()
    {
        InitializeComponent();
    }

    protected override void OnSectionButtonClicked(object sender, EventArgs e)
    {
        if (sender is Button button)
        {
            // Get the content section based on button name
            var contentName = button.Text.Contains("Location") ? "LocationSectionContent" :
                button.Text.Contains("Installation") ? "InstallationSectionContent" :
                "DeviceSectionContent";

            if (FindByName(contentName) is VerticalStackLayout content)
            {
                // Toggle visibility
                content.IsVisible = !content.IsVisible;

                // Update button text
                button.Text = button.Text.Replace(
                    content.IsVisible ? "▶" : "▼",
                    content.IsVisible ? "▼" : "▶"
                );
            }
        }
    }

    private void OnWaterPurveyorSelected(object? sender, EventArgs e)
    {
        if (sender is not Picker picker) return;
        CustomWaterPurveyor.IsVisible = picker.SelectedItem?.ToString() == "Custom...";
    }
}