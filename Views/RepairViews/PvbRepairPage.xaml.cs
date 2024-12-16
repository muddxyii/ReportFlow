namespace ReportFlow.Views.RepairViews;

[QueryProperty(nameof(ViewModel), "ViewModel")]
public partial class PvbRepairPage
{
    public PvbRepairPage()
    {
        InitializeComponent();
    }
    
    protected override void OnSectionButtonClicked(object sender, EventArgs e)
    {
        if (sender is Button button)
        {
            var contentName = button.Text.Contains("PVB") ? "PvbContent" : "";
            if (FindByName(contentName) is VerticalStackLayout content)
            {
                content.IsVisible = !content.IsVisible;
                button.Text = button.Text.Replace(
                    content.IsVisible ? "▶" : "▼", 
                    content.IsVisible ? "▼" : "▶"
                );
            }
        }
    }
}