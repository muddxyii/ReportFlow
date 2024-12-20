using ReportFlow.Interfaces;
using ReportFlow.Models.Final;
using ReportFlow.Models.Info;
using ReportFlow.Models.Repair;
using ReportFlow.Services.ReportServices;
using DeviceInfo = ReportFlow.Models.Info.DeviceInfo;

namespace ReportFlow.Models;

public class ReportData
{
    public ReportMetadata Metadata { get; set; }

    // Info
    public CustomerInfo CustomerInfo { get; set; }
    public DeviceInfo DeviceInfo { get; set; }

    // Tests
    // TODO: Make Test Models

    // Repairs
    public RepairInfo RepairInfo { get; set; }

    // Final Info
    public FinalInfo FinalInfo { get; set; }

    public ReportData(Dictionary<string, string> oldPdfData)
    {
        // Generate Report Id
        Metadata = new ReportMetadata(Guid.NewGuid().ToString());

        // Load Models
        CustomerInfo = CustomerInfo.FromFormFields(oldPdfData);
        DeviceInfo = DeviceInfo.FromFormFields(oldPdfData);

        RepairInfo = RepairInfo.FromFormFields(oldPdfData);

        FinalInfo = FinalInfo.FromFormFields(oldPdfData);
    }
}