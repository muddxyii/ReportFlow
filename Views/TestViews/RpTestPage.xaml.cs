namespace ReportFlow.Views.TestViews;

[QueryProperty(nameof(ViewModel), "ViewModel")]
public partial class RpTestPage
{
    public RpTestPage()
    {
        InitializeComponent();
    }
    
    protected override void OnSectionButtonClicked(object sender, EventArgs e)
    {
        if (sender is Button button)
        {
            // Get the content section based on button name
            var contentName = button.Text.Contains("Pressure") ? "LinePressureContent" :
                button.Text.Contains("Shutoff") ? "ShutoffValveContent" :
                button.Text.Contains("Check") ? "CheckValvesContent" :
                "ReliefValveContent";

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
}