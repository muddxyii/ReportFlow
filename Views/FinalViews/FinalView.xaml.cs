namespace ReportFlow.Views.FinalViews;

[QueryProperty(nameof(ViewModel), "ViewModel")]
public partial class FinalView
{
    public FinalView()
    {
        InitializeComponent();
    }

    protected override void OnSectionButtonClicked(object sender, EventArgs e)
    {
        if (sender is Button button)
        {
            // Get the content section based on button name
            var contentName = button.Text.Contains("Fail") ? "InitialSectionContent" :
                button.Text.Contains("Repair") ? "RepairedSectionContent" :
                button.Text.Contains("Comments") ? "CommentsSectionContent" :
                "FinalSectionContent";

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