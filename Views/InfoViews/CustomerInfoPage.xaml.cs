namespace ReportFlow.Views.InfoViews;

[QueryProperty(nameof(ViewModel), "ViewModel")]
public partial class CustomerInfoPage
{
    public CustomerInfoPage()
    {
        InitializeComponent();
    }
    
    protected override void OnSectionButtonClicked(object sender, EventArgs e)
    {
        if (sender is Button button)
        {
            // Get the content section based on button name
            var contentName = button.Text.Contains("Permit") ? "PermitAccountContent" :
                button.Text.Contains("Owner") ? "OwnerSectionContent" :
                "RepresentativeSectionContent";
            
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