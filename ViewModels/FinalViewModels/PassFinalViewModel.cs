namespace ReportFlow.ViewModels.FinalViewModels;

public class PassFinalViewModel : BaseBackflowViewModel
{
    #region PassFinalViewModel Properties

    Dictionary<string, string> _failedFieldsToSave = new Dictionary<string, string>();
    Dictionary<string, string> _repairedFieldsToSave = new Dictionary<string, string>();
    Dictionary<string, string> _passedFieldsToSave = new Dictionary<string, string>();

    private bool _showInitialFields;
    private bool _showRepairedFields;
    private bool _showPassedFields;

    public bool ShowInitialFields
    {
        get => _showInitialFields;
        set
        {
            _showInitialFields = value;
            OnPropertyChanged(nameof(ShowInitialFields));
        }
    }

    public bool ShowRepairedFields
    {
        get => _showRepairedFields;
        set
        {
            _showRepairedFields = value;
            OnPropertyChanged(nameof(ShowRepairedFields));
        }
    }

    public bool ShowPassedFields
    {
        get => _showPassedFields;
        set
        {
            _showPassedFields = value;
            OnPropertyChanged(nameof(ShowPassedFields));
        }
    }

    #endregion

    #region Dropdown Items

    public List<String> TesterNameOptions { get; } =
        ["MIGUEL CARRILLO", "JAYSON PADILLA", "JACOB S. PADILLA"];

    public List<string> TesterNoOptions { get; } =
    [
        "03-2105139", "03-2106135", "03-2105140",
        "40604", "42332", "40609", "60291"
    ];

    public List<string> TestKitSerialOptions { get; } =
        ["02130411", "06122624", "03100226", "10171937", "07172355"];

    #endregion

    #region Tester Fields

    private string? _initialTester;
    private string? _repairedTester;
    private string? _finalTester;

    public string? InitialTester
    {
        get => _initialTester;
        set
        {
            _initialTester = value;
            _failedFieldsToSave["InitialTester"] = value ?? "";
            OnPropertyChanged(nameof(InitialTester));
        }
    }

    public string? RepairedTester
    {
        get => _repairedTester;
        set
        {
            _repairedTester = value;
            _repairedFieldsToSave["RepairedTester"] = value ?? "";
            OnPropertyChanged(nameof(RepairedTester));
        }
    }

    public string? FinalTester
    {
        get => _finalTester;
        set
        {
            _finalTester = value;
            _passedFieldsToSave["FinalTester"] = value ?? "";
            OnPropertyChanged(nameof(FinalTester));
        }
    }

    #endregion

    #region Tester Cert No Fields

    private string? _initialTesterNo;
    private string? _repairedTesterNo;
    private string? _finalFinalTesterNo;

    public string? InitialTesterNo
    {
        get => _initialTesterNo;
        set
        {
            _initialTesterNo = value;
            _failedFieldsToSave["InitialTesterNo"] = value ?? "";
            OnPropertyChanged(nameof(InitialTesterNo));
        }
    }

    public string? RepairedTesterNo
    {
        get => _repairedTesterNo;
        set
        {
            _repairedTesterNo = value;
            _repairedFieldsToSave["RepairedTesterNo"] = value ?? "";
            OnPropertyChanged(nameof(RepairedTesterNo));
        }
    }

    public string? FinalTesterNo
    {
        get => _finalFinalTesterNo;
        set
        {
            _finalFinalTesterNo = value;
            _passedFieldsToSave["FinalTesterNo"] = value ?? "";
            OnPropertyChanged(nameof(FinalTesterNo));
        }
    }

    #endregion

    #region Date Related Fields

    private DateTime _dateFailed = DateTime.Today;
    private DateTime _dateRepaired = DateTime.Today;
    private DateTime _datePassed = DateTime.Today;

    public DateTime DateFailed
    {
        get => _dateFailed;
        set
        {
            _dateFailed = value;
            _failedFieldsToSave["DateFailed"] = value.ToString("M/d/yyyy") ?? string.Empty;
            OnPropertyChanged(nameof(DateFailed));
        }
    }

    public DateTime DateRepaired
    {
        get => _dateRepaired;
        set
        {
            _dateRepaired = value;
            _repairedFieldsToSave["DateRepaired"] = value.ToString("M/d/yyyy") ?? string.Empty;
            OnPropertyChanged(nameof(DateRepaired));
        }
    }

    public DateTime DatePassed
    {
        get => _datePassed;
        set
        {
            _datePassed = value;
            _passedFieldsToSave["DatePassed"] = value.ToString("M/d/yyyy") ?? string.Empty;
            OnPropertyChanged(nameof(DatePassed));
        }
    }

    #endregion

    #region Test Kit Serial Fields

    private string? _initialTestKitSerial;
    private string? _repairedTestKitSerial;
    private string? _finalTestKitSerial;

    public string? InitialTestKitSerial
    {
        get => _initialTestKitSerial;
        set
        {
            _initialTestKitSerial = value;
            _failedFieldsToSave["InitialTestKitSerial"] = value ?? "";
            OnPropertyChanged(nameof(InitialTestKitSerial));
        }
    }

    public string? RepairedTestKitSerial
    {
        get => _repairedTestKitSerial;
        set
        {
            _repairedTestKitSerial = value;
            _repairedFieldsToSave["RepairedTestKitSerial"] = value ?? "";
            OnPropertyChanged(nameof(RepairedTestKitSerial));
        }
    }

    public string? FinalTestKitSerial
    {
        get => _finalTestKitSerial;
        set
        {
            _finalTestKitSerial = value;
            _passedFieldsToSave["FinalTestKitSerial"] = value ?? "";
            OnPropertyChanged(nameof(FinalTestKitSerial));
        }
    }

    #endregion

    #region Comments Field

    private string? _comments;

    public string? Comments
    {
        get => _comments;
        set
        {
            _comments = value;
            OnPropertyChanged(nameof(Comments));
        }
    }

    #endregion

    #region Constructors
    
    public PassFinalViewModel()
    {
        _showInitialFields = false;
        _showRepairedFields = false;
        _showPassedFields = false;
    }

    public PassFinalViewModel(bool showInitialFields, bool showRepairedFields, bool showPassedFields)
    {
        _showInitialFields = showInitialFields;
        _showRepairedFields = showRepairedFields;
        _showPassedFields = showPassedFields;
    }

    #endregion
    
    protected override async Task OnNext()
    {
        // Validate and save fields
        if (ShowInitialFields)
        {
            if (!await ValidateFailedBy()) return;
            DateFailed = _dateFailed;
            SaveFormData(_failedFieldsToSave);
        }

        if (ShowRepairedFields)
        {
            if (!await ValidateRepairedBy()) return;
            DateRepaired = _dateRepaired;
            SaveFormData(_repairedFieldsToSave);
        }

        if (ShowPassedFields)
        {
            if (!await ValidatePassedBy()) return;
            DatePassed = _datePassed;
            SaveFormData(_passedFieldsToSave);
        }

        // Save Comments
        Dictionary<string, string> formFields = new Dictionary<string, string>()
        {
            { "ReportComments", Comments?.ToUpper() ?? string.Empty },
        };
        SaveFormData(formFields);

        // Save as pdf        
        string? serialNo = FormData.GetValueOrDefault("SerialNo");
        string fileName = $"{serialNo ?? "Unknown"}_{DateTime.Now:yyyy-M-d}.pdf";
        await SavePdf(fileName);
    }

    #region Validation

    private async Task<bool> ValidateFailedBy()
    {
        // List of required fields with their display names
        var requiredFields = new Dictionary<string, string>
        {
            { nameof(InitialTester), "[Failed] Tester Name" },
            { nameof(InitialTesterNo), "[Failed] Tester Number" },
            { nameof(InitialTestKitSerial), "[Failed] - Test Kit Serial" }
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
                return false;
            }
        }

        return true;
    }

    private async Task<bool> ValidateRepairedBy()
    {
        // List of required fields with their display names
        var requiredFields = new Dictionary<string, string>
        {
            { nameof(RepairedTester), "[Repaired] Tester Name" },
            { nameof(RepairedTesterNo), "[Repaired] Tester Number" },
            { nameof(RepairedTestKitSerial), "[Repaired] - Test Kit Serial" }
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
                return false;
            }
        }

        return true;
    }

    private async Task<bool> ValidatePassedBy()
    {
        // List of required fields with their display names
        var requiredFields = new Dictionary<string, string>
        {
            { nameof(FinalTester), "[Final] Tester Name" },
            { nameof(FinalTesterNo), "[Final] Tester Number" },
            { nameof(FinalTestKitSerial), "[Final] Test Kit Serial" }
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
                return false;
            }
        }

        return true;
    }

    #endregion
}