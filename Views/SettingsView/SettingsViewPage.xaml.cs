namespace ReportFlow.Views.SettingsView;

public partial class SettingsViewPage : ContentPage
{
    public SettingsViewPage()
    {
        InitializeComponent();
    }

    private void OnSectionButtonClicked(object? sender, EventArgs e)
    {
        if (sender is Button button)
        {
            // Get the content section based on button name
            var contentName = button.Text.Contains("Test") ? "TesterInfoContent" : "RepresentativeSectionContent";

            var content = FindByName(contentName) as VerticalStackLayout;
            if (content != null)
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
}