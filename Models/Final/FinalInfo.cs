namespace ReportFlow.Models.Final;

public class TesterInfo
{
    public string? Name { get; set; } = string.Empty;
    public string? CertificationNo { get; set; } = string.Empty;
    public string? TestKitSerial { get; set; } = string.Empty;
    public DateTime Date { get; set; } = DateTime.Today;
}

public class FinalInfo
{
    public TesterInfo? InitialTest { get; set; }
    public TesterInfo? RepairedTest { get; set; }
    public TesterInfo? FinalTest { get; set; }
    public string? Comments { get; set; } = string.Empty;

    public Dictionary<string, string> ToFormFields()
    {
        var fields = new Dictionary<string, string>();

        if (InitialTest != null)
        {
            fields.Add("InitialTester", InitialTest.Name ?? string.Empty);
            fields.Add("InitialTesterNo", InitialTest.CertificationNo ?? string.Empty);
            fields.Add("InitialTestKitSerial", InitialTest.TestKitSerial ?? string.Empty);
            fields.Add("DateFailed", InitialTest.Date.ToString("M/d/yyyy"));
        }

        if (RepairedTest != null)
        {
            fields.Add("RepairedTester", RepairedTest.Name ?? string.Empty);
            fields.Add("RepairedTesterNo", RepairedTest.CertificationNo ?? string.Empty);
            fields.Add("RepairedTestKitSerial", RepairedTest.TestKitSerial ?? string.Empty);
            fields.Add("DateRepaired", RepairedTest.Date.ToString("M/d/yyyy"));
        }

        if (FinalTest != null)
        {
            fields.Add("FinalTester", FinalTest.Name ?? string.Empty);
            fields.Add("FinalTesterNo", FinalTest.CertificationNo ?? string.Empty);
            fields.Add("FinalTestKitSerial", FinalTest.TestKitSerial ?? string.Empty);
            fields.Add("DatePassed", FinalTest.Date.ToString("M/d/yyyy"));
        }

        fields.Add("ReportComments", Comments?.ToUpper() ?? string.Empty);
        return fields;
    }

    public static FinalInfo FromFormFields(Dictionary<string, string> formData)
    {
        return new FinalInfo
        {
            InitialTest = new TesterInfo
            {
                Name = formData.GetValueOrDefault("InitialTester"),
                CertificationNo = formData.GetValueOrDefault("InitialTesterNo"),
                TestKitSerial = formData.GetValueOrDefault("InitialTestKitSerial"),
                Date = DateTime.Parse(formData.GetValueOrDefault("DateFailed") ?? DateTime.Today.ToString("M/d/yyyy"))
            },
            RepairedTest = new TesterInfo
            {
                Name = formData.GetValueOrDefault("RepairedTester"),
                CertificationNo = formData.GetValueOrDefault("RepairedTesterNo"),
                TestKitSerial = formData.GetValueOrDefault("RepairedTestKitSerial"),
                Date = DateTime.Parse(formData.GetValueOrDefault("DateRepaired") ?? DateTime.Today.ToString("M/d/yyyy"))
            },
            FinalTest = new TesterInfo
            {
                Name = formData.GetValueOrDefault("FinalTester"),
                CertificationNo = formData.GetValueOrDefault("FinalTesterNo"),
                TestKitSerial = formData.GetValueOrDefault("FinalTestKitSerial"),
                Date = DateTime.Parse(formData.GetValueOrDefault("DatePassed") ?? DateTime.Today.ToString("M/d/yyyy"))
            },
            Comments = formData.GetValueOrDefault("ReportComments")
        };
    }
}