using ABFReportEditor.Views;
using ABFReportEditor.Views.FinalViews;
using ABFReportEditor.Views.InfoViews;
using ABFReportEditor.Views.RepairViews;
using ABFReportEditor.Views.TestViews;

namespace ABFReportEditor;

public partial class AppShell : Shell
{
    public AppShell()
    {
        InitializeComponent();
        
        // Register InfoViews
        Routing.RegisterRoute("CustomerInfo", typeof(CustomerInfoPage));
        Routing.RegisterRoute("DeviceInfo", typeof(DeviceInfoPage));
        
        // Register TestViews
        Routing.RegisterRoute("RpTest", typeof(RpTestPage));
        Routing.RegisterRoute("DcTest", typeof(DcTestPage));
        Routing.RegisterRoute("PvbTest", typeof(PvbTestPage));
        
        // Repair RepairViews
        Routing.RegisterRoute("RpRepair", typeof(RpRepairPage));
        Routing.RegisterRoute("DcRepair", typeof(DcRepairPage));
        //Routing.RegisterRoute("PvbRepair", typeof(PvbRepairPage));
        
        // Register FinalViews
        Routing.RegisterRoute("PassFinal", typeof(PassFinalView));
    }
}