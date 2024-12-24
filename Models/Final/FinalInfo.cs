namespace ReportFlow.Models.Final;

public class TesterInfo
{
    public string? Name { get; set; } = string.Empty;
    public string? CertNo { get; set; } = string.Empty;
    public string? TestKitSerial { get; set; } = string.Empty;
    public DateTime Date { get; set; } = DateTime.Today;
}

public class FinalInfo
{
    public TesterInfo? InitialTest { get; set; }
    public TesterInfo? RepairedTest { get; set; }
    public TesterInfo? FinalTest { get; set; }
    public string? Comments { get; set; } = string.Empty;

    public Dictionary<string, string> ToFormFields(bool failed, bool repaired, bool passed)
    {
        var fields = new Dictionary<string, string>();

        if (InitialTest != null && failed)
        {
            fields.Add("InitialTester", InitialTest.Name ?? string.Empty);
            fields.Add("InitialTesterNo", InitialTest.CertNo ?? string.Empty);
            fields.Add("InitialTestKitSerial", InitialTest.TestKitSerial ?? string.Empty);
            if (!string.IsNullOrEmpty(InitialTest.Name))
                fields.Add("DateFailed", InitialTest.Date.ToString("M/d/yyyy"));
        }

        if (RepairedTest != null && repaired)
        {
            fields.Add("RepairedTester", RepairedTest.Name ?? string.Empty);
            fields.Add("RepairedTesterNo", RepairedTest.CertNo ?? string.Empty);
            fields.Add("RepairedTestKitSerial", RepairedTest.TestKitSerial ?? string.Empty);
            if (!string.IsNullOrEmpty(RepairedTest.Name))
                fields.Add("DateRepaired", RepairedTest.Date.ToString("M/d/yyyy"));
        }

        if (FinalTest != null && passed)
        {
            fields.Add("FinalTester", FinalTest.Name ?? string.Empty);
            fields.Add("FinalTesterNo", FinalTest.CertNo ?? string.Empty);
            fields.Add("FinalTestKitSerial", FinalTest.TestKitSerial ?? string.Empty);
            if (!string.IsNullOrEmpty(FinalTest.Name))
                fields.Add("DatePassed", FinalTest.Date.ToString("M/d/yyyy"));
        }

        fields.Add("ReportComments", Comments?.ToUpper() ?? string.Empty);
        return fields;
    }

    public static FinalInfo FromFormFields(Dictionary<string, string> formData)
    {
        var defaults = new
        {
            TesterName = Preferences.Default.Get("TesterName", string.Empty),
            TestKitSerial = Preferences.Default.Get("TestKitSerial", string.Empty),
            TestCertNo = Preferences.Default.Get("TestCertNo", string.Empty),
            RepairCertNo = Preferences.Default.Get("RepairCertNo", string.Empty)
        };

        return new FinalInfo
        {
            InitialTest = new TesterInfo
            {
                Name = formData.GetValueOrDefault("InitialTester", defaults.TesterName),
                CertNo = formData.GetValueOrDefault("InitialTesterNo", defaults.TestCertNo),
                TestKitSerial = formData.GetValueOrDefault("InitialTestKitSerial", defaults.TestKitSerial),
                Date = DateTime.Parse(formData.GetValueOrDefault("DateFailed") ?? DateTime.Today.ToString("M/d/yyyy"))
            },
            RepairedTest = new TesterInfo
            {
                Name = formData.GetValueOrDefault("RepairedTester", defaults.TesterName),
                CertNo = formData.GetValueOrDefault("RepairedTesterNo", defaults.RepairCertNo),
                TestKitSerial = formData.GetValueOrDefault("RepairedTestKitSerial", defaults.TestKitSerial),
                Date = DateTime.Parse(formData.GetValueOrDefault("DateRepaired") ?? DateTime.Today.ToString("M/d/yyyy"))
            },
            FinalTest = new TesterInfo
            {
                Name = formData.GetValueOrDefault("FinalTester", defaults.TesterName),
                CertNo = formData.GetValueOrDefault("FinalTesterNo", defaults.TestCertNo),
                TestKitSerial = formData.GetValueOrDefault("FinalTestKitSerial", defaults.TestKitSerial),
                Date = DateTime.Parse(formData.GetValueOrDefault("DatePassed") ?? DateTime.Today.ToString("M/d/yyyy"))
            },
            Comments = formData.GetValueOrDefault("ReportComments")
        };
    }
}