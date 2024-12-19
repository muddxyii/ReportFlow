using ReportFlow.Interfaces;
using ReportFlow.Models.Info;

namespace ReportFlow.Models;

public class ReportData
{
    public Dictionary<string, string> OldPdfData { get; init; }
    public string ReportId { get; init; }

    public CustomerInfo CustomerInfo { get; set; }


    public ReportData(Dictionary<string, string> oldPdfData)
    {
        // Generate Report Id
        ReportId = Guid.NewGuid().ToString();

        // Save Olf Pdf Data
        OldPdfData = oldPdfData;

        // Load Models
        CustomerInfo = CustomerInfo.FromFormFields(oldPdfData);
    }
}