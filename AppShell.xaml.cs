using ABFReportEditor.Views;

namespace ABFReportEditor;

public partial class AppShell : Shell
{
    public AppShell()
    {
        InitializeComponent();
        
        Routing.RegisterRoute("CustomerInfo", typeof(CustomerInfoPage));
        Routing.RegisterRoute("DeviceInfo", typeof(DeviceInfoPage));
    }
}