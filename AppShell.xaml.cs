using ReportFlow.Views.FinalViews;
using ReportFlow.Views.InfoViews;
using ReportFlow.Views.RepairViews;
using ReportFlow.Views.ReportViews;
using ReportFlow.Views.SettingsView;
using ReportFlow.Views.TestViews;

namespace ReportFlow;

public partial class AppShell : Shell
{
    public AppShell()
    {
        InitializeComponent();

        // Register MainPage
        Routing.RegisterRoute("MainPage", typeof(MainPage));

        // Register Settings Page
        Routing.RegisterRoute("SettingsPage", typeof(SettingsViewPage));

        // Register Report Browser
        Routing.RegisterRoute("ReportBrowser", typeof(ReportBrowserPage));

        // Register InfoViews
        Routing.RegisterRoute("CustomerInfo", typeof(CustomerInfoPage));
        Routing.RegisterRoute("DeviceInfo", typeof(DeviceInfoPage));

        // Register TestViews
        Routing.RegisterRoute("RpTest", typeof(RpTestPage));
        Routing.RegisterRoute("DcTest", typeof(DcTestPage));
        Routing.RegisterRoute("ScTest", typeof(ScTestPage));
        Routing.RegisterRoute("PvbTest", typeof(PvbTestPage));
        Routing.RegisterRoute("SvbTest", typeof(SvbTestPage));

        // Repair RepairViews
        Routing.RegisterRoute("RpRepair", typeof(RpRepairPage));
        Routing.RegisterRoute("DcRepair", typeof(DcRepairPage));
        Routing.RegisterRoute("ScRepair", typeof(ScRepairPage));
        Routing.RegisterRoute("PvbRepair", typeof(PvbRepairPage));
        Routing.RegisterRoute("SvbRepair", typeof(SvbRepairPage));

        // Register FinalViews
        Routing.RegisterRoute("PassFinal", typeof(FinalView));
    }
}