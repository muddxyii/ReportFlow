namespace ReportFlow.Views.RepairViews;

[QueryProperty(nameof(ViewModel), "ViewModel")]
public partial class RpRepairPage
{
    public RpRepairPage()
    {
        InitializeComponent();
    }
    
    protected override void OnSectionButtonClicked(object sender, EventArgs e)
    {
        if (sender is Button button)
        {
            // Get the content section based on button name
            var contentName = button.Text.Contains("1") ? "Cv1Content" :
                button.Text.Contains("2") ? "Cv2Content" : 
                "RvContent";

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