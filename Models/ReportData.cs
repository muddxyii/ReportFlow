using ReportFlow.Models.Final;
using ReportFlow.Models.Info;
using ReportFlow.Models.Repair;
using ReportFlow.Models.Test;
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
    public TestInfo InitialTest { get; set; }
    public TestInfo FinalTest { get; set; }

    // Repairs
    public RepairInfo RepairInfo { get; set; }

    // Final Info
    public FinalInfo FinalInfo { get; set; }

    public ReportData()
    {
    }

    public ReportData(Dictionary<string, string> oldPdfData)
    {
        // Generate Report Id
        Metadata = new ReportMetadata(Guid.NewGuid().ToString());

        // Load Models
        CustomerInfo = CustomerInfo.FromFormFields(oldPdfData);
        DeviceInfo = DeviceInfo.FromFormFields(oldPdfData);

        InitialTest = TestInfo.FromFormFields(oldPdfData);
        FinalTest = TestInfo.FromFormFields(oldPdfData);

        RepairInfo = RepairInfo.FromFormFields(oldPdfData);

        FinalInfo = FinalInfo.FromFormFields(oldPdfData);
    }

    public Dictionary<string, string> ToFormFields()
    {
        var result = new Dictionary<string, string>();

        // Add Customer Info
        foreach (var field in CustomerInfo.ToFormFields())
            result[field.Key] = field.Value;

        // Add Device Info
        foreach (var field in DeviceInfo.ToFormFields())
            result[field.Key] = field.Value;

        // Add Test Info
        if (RepairInfo.WasRepaired) // Failed, Repaired, Passed
        {
            foreach (var field in FinalTest.ToPassedFormFields())
                result[field.Key] = field.Value;
            foreach (var field in InitialTest.ToFailedFormFields())
                result[field.Key] = field.Value;
        }
        else if (RepairInfo.SkippedRepair) // Failed, Skipped Repair
        {
            foreach (var field in InitialTest.ToFailedFormFields())
                result[field.Key] = field.Value;
        }
        else // Passed
        {
            foreach (var field in InitialTest.ToPassedFormFields())
                result[field.Key] = field.Value;
        }

        // Add Repair Info
        foreach (var field in RepairInfo.ToFormFields())
            result[field.Key] = field.Value;

        // Add Final Info
        foreach (var field in FinalInfo.ToFormFields())
            result[field.Key] = field.Value;

        return result;
    }
}