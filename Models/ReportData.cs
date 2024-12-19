using ReportFlow.Interfaces;
using ReportFlow.Models.Final;
using ReportFlow.Models.Info;
using DeviceInfo = ReportFlow.Models.Info.DeviceInfo;

namespace ReportFlow.Models;

public class ReportData
{
    public Dictionary<string, string> OldPdfData { get; init; }
    public string ReportId { get; init; }

    // Info
    public CustomerInfo CustomerInfo { get; set; }
    public DeviceInfo DeviceInfo { get; set; }

    // Tests
    // TODO: Make Test Models

    // Repairs
    // TODO: Make Repair Model

    // Final Info
    public FinalInfo FinalInfo { get; set; }

    public ReportData(Dictionary<string, string> oldPdfData)
    {
        // Generate Report Id
        ReportId = Guid.NewGuid().ToString();

        // Save Olf Pdf Data
        OldPdfData = oldPdfData;

        // Load Models
        CustomerInfo = CustomerInfo.FromFormFields(oldPdfData);
        DeviceInfo = DeviceInfo.FromFormFields(oldPdfData);
    }
}