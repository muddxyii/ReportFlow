using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ReportFlow.Views.TestViews;

[QueryProperty(nameof(ViewModel), "ViewModel")]
public partial class PvbTestPage
{
    public PvbTestPage()
    {
        InitializeComponent();
    }
    
    protected override void OnSectionButtonClicked(object sender, EventArgs e)
    {
        if (sender is Button button)
        {
            // Get the content section based on button name
            var contentName = button.Text.Contains("Line Pressure") ? "LinePressureContent" :
                button.Text.Contains("Shutoff") ? "ShutoffValveContent" :
                button.Text.Contains("Back Pressure") ? "BackPressureContent" :
                button.Text.Contains("PVB") ? "PvbCkContent" :
                "AirInletContent";

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