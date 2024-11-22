namespace ABFReportEditor.ViewModels.FinalViewModels;

public class PassFinalViewModel : BaseBackflowViewModel
{
    // Dropdown options
    public List<String> TesterNameOptions { get; } =
        ["CURTIS JACQUES", "MIGUEL CARILLO", "JAYSON PADILLA", "JACOB S. PADILLA"];

    public List<string> TesterNoOptions { get; } =
    [
        "03-2105139", "03-2106135", "03-2105140",
        "40604", "42332", "40609", "60291"
    ];

    public List<string> TestKitSerialOptions { get; } =
        ["02130411", "06122624", "03100226", "10171937", "07172355"];

    // Private fields
    private string? _testerName;
    private DateTime _datePassed = DateTime.Today;
    private string? _testerNo;
    private string? _testKitSerial;
    private string? _comments;

    // Properties
    public string? TesterName
    {
        get => _testerName;
        set
        {
            _testerName = value;
            OnPropertyChanged(nameof(TesterName));
        }
    }

    public string? TesterNo
    {
        get => _testerNo;
        set
        {
            _testerNo = value;
            OnPropertyChanged(nameof(TesterNo));
        }
    }
    
    public DateTime DatePassed
    {
        get => _datePassed;
        set
        {
            _datePassed = value;
            OnPropertyChanged(nameof(DatePassed));
        }
    }

    public string? TestKitSerial
    {
        get => _testKitSerial;
        set
        {
            _testKitSerial = value;
            OnPropertyChanged(nameof(TestKitSerial));
        }
    }
    
    public string? Comments
    {
        get => _comments;
        set
        {
            _comments = value;
            OnPropertyChanged(nameof(Comments));
        }
    }


    // Methods
    protected override void LoadFormFields(Dictionary<string, string> formFields)
    {
        // Don't load previous fields
    }

    protected override async Task OnNext()
    {
        // TODO: Implement share pdf logic
        
        // List of required fields with their display names
        var requiredFields = new Dictionary<string, string>
        {
            { nameof(TesterName), "Tester Name" },
            { nameof(TesterNo), "Tester Number" },
            { nameof(TestKitSerial), "Test Kit Serial" }
        };

        // Check for missing required fields
        foreach (var field in requiredFields)
        {
            var propertyValue = GetType().GetProperty(field.Key)?.GetValue(this) as string;
            if (string.IsNullOrEmpty(propertyValue))
            {
                await Application.Current.MainPage.DisplayAlert(
                    "Fields are empty",
                    $"The field '{field.Value}' has not been filled.",
                    "OK"
                );
                return;
            }
        }
        
        // Save form data
        Dictionary<string, string> formFields = new Dictionary<string, string>()
        {
            { "FinalTester", TesterName ?? string.Empty },
            { "DatePassed", DatePassed.ToString("M/d/yyyy") ?? string.Empty },
            { "FinalTesterNo", TesterNo ?? string.Empty },
            { "FinalTestKitSerial", TestKitSerial ?? string.Empty },
            { "ReportComments", Comments?.ToUpper() ?? string.Empty },
        };
        SaveFormData(formFields);

        // Save as pdf        
        string? serialNo = FormData.GetValueOrDefault("SerialNo");
        string fileName = $"{serialNo ?? "Unknown"}_{DateTime.Now:yyyy-M-d}.pdf";
        await SavePdf(fileName);
    }
}