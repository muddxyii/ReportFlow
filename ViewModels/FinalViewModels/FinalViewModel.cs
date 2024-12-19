using ReportFlow.Models.Final;
using ReportFlow.ViewModels.InfoViewModels;

namespace ReportFlow.ViewModels.FinalViewModels;

public class FinalViewModel : BaseBackflowViewModel
{
    private FinalInfo _finalInfo;
    private bool _showInitialFields;
    private bool _showRepairedFields;
    private bool _showPassedFields;

    #region Show Fields Properties

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

    public List<string> TesterNameOptions { get; } =
        ["MIGUEL CARRILLO", "JAYSON PADILLA", "JACOB S. PADILLA"];

    public List<string> TesterNoOptions { get; } =
    [
        "03-2105139", "03-2106135", "03-2105140",
        "40604", "42332", "40609", "60291"
    ];

    public List<string> TestKitSerialOptions { get; } =
        ["02130411", "06122624", "03100226", "10171937", "07172355"];

    #endregion

    #region Initial Test Properties

    public string? InitialTester
    {
        get => _finalInfo.InitialTest?.Name;
        set
        {
            _finalInfo.InitialTest ??= new TesterInfo();
            _finalInfo.InitialTest.Name = value;
            OnPropertyChanged(nameof(InitialTester));
        }
    }

    public string? InitialTesterNo
    {
        get => _finalInfo.InitialTest?.CertificationNo;
        set
        {
            _finalInfo.InitialTest ??= new TesterInfo();
            _finalInfo.InitialTest.CertificationNo = value;
            OnPropertyChanged(nameof(InitialTesterNo));
        }
    }

    public string? InitialTestKitSerial
    {
        get => _finalInfo.InitialTest?.TestKitSerial;
        set
        {
            _finalInfo.InitialTest ??= new TesterInfo();
            _finalInfo.InitialTest.TestKitSerial = value;
            OnPropertyChanged(nameof(InitialTestKitSerial));
        }
    }

    public DateTime DateFailed
    {
        get => _finalInfo.InitialTest?.Date ?? DateTime.Today;
        set
        {
            _finalInfo.InitialTest ??= new TesterInfo();
            _finalInfo.InitialTest.Date = value;
            OnPropertyChanged(nameof(DateFailed));
        }
    }

    #endregion

    #region Repaired Test Properties

    public string? RepairedTester
    {
        get => _finalInfo.RepairedTest?.Name;
        set
        {
            _finalInfo.RepairedTest ??= new TesterInfo();
            _finalInfo.RepairedTest.Name = value;
            OnPropertyChanged(nameof(RepairedTester));
        }
    }

    public string? RepairedTesterNo
    {
        get => _finalInfo.RepairedTest?.CertificationNo;
        set
        {
            _finalInfo.RepairedTest ??= new TesterInfo();
            _finalInfo.RepairedTest.CertificationNo = value;
            OnPropertyChanged(nameof(RepairedTesterNo));
        }
    }

    public string? RepairedTestKitSerial
    {
        get => _finalInfo.RepairedTest?.TestKitSerial;
        set
        {
            _finalInfo.RepairedTest ??= new TesterInfo();
            _finalInfo.RepairedTest.TestKitSerial = value;
            OnPropertyChanged(nameof(RepairedTestKitSerial));
        }
    }

    public DateTime DateRepaired
    {
        get => _finalInfo.RepairedTest?.Date ?? DateTime.Today;
        set
        {
            _finalInfo.RepairedTest ??= new TesterInfo();
            _finalInfo.RepairedTest.Date = value;
            OnPropertyChanged(nameof(DateRepaired));
        }
    }

    #endregion

    #region Final Test Properties

    public string? FinalTester
    {
        get => _finalInfo.FinalTest?.Name;
        set
        {
            _finalInfo.FinalTest ??= new TesterInfo();
            _finalInfo.FinalTest.Name = value;
            OnPropertyChanged(nameof(FinalTester));
        }
    }

    public string? FinalTesterNo
    {
        get => _finalInfo.FinalTest?.CertificationNo;
        set
        {
            _finalInfo.FinalTest ??= new TesterInfo();
            _finalInfo.FinalTest.CertificationNo = value;
            OnPropertyChanged(nameof(FinalTesterNo));
        }
    }

    public string? FinalTestKitSerial
    {
        get => _finalInfo.FinalTest?.TestKitSerial;
        set
        {
            _finalInfo.FinalTest ??= new TesterInfo();
            _finalInfo.FinalTest.TestKitSerial = value;
            OnPropertyChanged(nameof(FinalTestKitSerial));
        }
    }

    public DateTime DatePassed
    {
        get => _finalInfo.FinalTest?.Date ?? DateTime.Today;
        set
        {
            _finalInfo.FinalTest ??= new TesterInfo();
            _finalInfo.FinalTest.Date = value;
            OnPropertyChanged(nameof(DatePassed));
        }
    }

    #endregion

    #region Comments

    public string? Comments
    {
        get => _finalInfo.Comments;
        set
        {
            _finalInfo.Comments = value;
            OnPropertyChanged(nameof(Comments));
        }
    }

    #endregion

    #region Constructors

    public FinalViewModel(Dictionary<string, string>? formData,
        bool showInitialFields, bool showRepairedFields, bool showPassedFields) : base(formData)
    {
        _showInitialFields = showInitialFields;
        _showRepairedFields = showRepairedFields;
        _showPassedFields = showPassedFields;
        _finalInfo = FinalInfo.FromFormFields(FormData);
    }

    public FinalViewModel() : base(new Dictionary<string, string>())
    {
        _finalInfo = new FinalInfo();
    }

    #endregion

    #region Navigation Methods

    protected override async Task OnNext()
    {
        if (ShowInitialFields && !await ValidateFailedBy()) return;
        if (ShowRepairedFields && !await ValidateRepairedBy()) return;
        if (ShowPassedFields && !await ValidatePassedBy()) return;

        await SaveFormDataWithCache(_finalInfo.ToFormFields());

        var serialNo = FormData.GetValueOrDefault("SerialNo");
        var fileName = $"{serialNo ?? "Unknown"}_{DateTime.Now:yyyy-M-d}.pdf";
        await SavePdf(fileName);
    }

    protected override async Task OnBack()
    {
        var viewModel = new DeviceInfoViewModel(FormData);
        await Shell.Current.GoToAsync("DeviceInfo", new Dictionary<string, object>
        {
            ["ViewModel"] = viewModel
        });
    }

    #endregion

    #region Validation Methods

    private async Task<bool> ValidateFailedBy()
    {
        var requiredFields = new Dictionary<string, string>
        {
            { nameof(InitialTester), "[Failed] Tester Name" },
            { nameof(InitialTesterNo), "[Failed] Tester Number" },
            { nameof(InitialTestKitSerial), "[Failed] - Test Kit Serial" }
        };

        return await ValidateFields(requiredFields);
    }

    private async Task<bool> ValidateRepairedBy()
    {
        var requiredFields = new Dictionary<string, string>
        {
            { nameof(RepairedTester), "[Repaired] Tester Name" },
            { nameof(RepairedTesterNo), "[Repaired] Tester Number" },
            { nameof(RepairedTestKitSerial), "[Repaired] - Test Kit Serial" }
        };

        return await ValidateFields(requiredFields);
    }

    private async Task<bool> ValidatePassedBy()
    {
        var requiredFields = new Dictionary<string, string>
        {
            { nameof(FinalTester), "[Final] Tester Name" },
            { nameof(FinalTesterNo), "[Final] Tester Number" },
            { nameof(FinalTestKitSerial), "[Final] Test Kit Serial" }
        };

        return await ValidateFields(requiredFields);
    }

    private async Task<bool> ValidateFields(Dictionary<string, string> requiredFields)
    {
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