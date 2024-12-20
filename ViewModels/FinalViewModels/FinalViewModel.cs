using ReportFlow.Models;
using ReportFlow.Models.Final;
using ReportFlow.Models.Repair;
using ReportFlow.ViewModels.InfoViewModels;
using ReportFlow.ViewModels.TestViewModels;

namespace ReportFlow.ViewModels.FinalViewModels;

public class FinalViewModel : BaseBackflowViewModel
{
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
        get => Report.FinalInfo.InitialTest?.Name;
        set
        {
            Report.FinalInfo.InitialTest ??= new TesterInfo();
            Report.FinalInfo.InitialTest.Name = value;
            OnPropertyChanged(nameof(InitialTester));
        }
    }

    public string? InitialTesterNo
    {
        get => Report.FinalInfo.InitialTest?.CertificationNo;
        set
        {
            Report.FinalInfo.InitialTest ??= new TesterInfo();
            Report.FinalInfo.InitialTest.CertificationNo = value;
            OnPropertyChanged(nameof(InitialTesterNo));
        }
    }

    public string? InitialTestKitSerial
    {
        get => Report.FinalInfo.InitialTest?.TestKitSerial;
        set
        {
            Report.FinalInfo.InitialTest ??= new TesterInfo();
            Report.FinalInfo.InitialTest.TestKitSerial = value;
            OnPropertyChanged(nameof(InitialTestKitSerial));
        }
    }

    public DateTime DateFailed
    {
        get => Report.FinalInfo.InitialTest?.Date ?? DateTime.Today;
        set
        {
            Report.FinalInfo.InitialTest ??= new TesterInfo();
            Report.FinalInfo.InitialTest.Date = value;
            OnPropertyChanged(nameof(DateFailed));
        }
    }

    #endregion

    #region Repaired Test Properties

    public string? RepairedTester
    {
        get => Report.FinalInfo.RepairedTest?.Name;
        set
        {
            Report.FinalInfo.RepairedTest ??= new TesterInfo();
            Report.FinalInfo.RepairedTest.Name = value;
            OnPropertyChanged(nameof(RepairedTester));
        }
    }

    public string? RepairedTesterNo
    {
        get => Report.FinalInfo.RepairedTest?.CertificationNo;
        set
        {
            Report.FinalInfo.RepairedTest ??= new TesterInfo();
            Report.FinalInfo.RepairedTest.CertificationNo = value;
            OnPropertyChanged(nameof(RepairedTesterNo));
        }
    }

    public string? RepairedTestKitSerial
    {
        get => Report.FinalInfo.RepairedTest?.TestKitSerial;
        set
        {
            Report.FinalInfo.RepairedTest ??= new TesterInfo();
            Report.FinalInfo.RepairedTest.TestKitSerial = value;
            OnPropertyChanged(nameof(RepairedTestKitSerial));
        }
    }

    public DateTime DateRepaired
    {
        get => Report.FinalInfo.RepairedTest?.Date ?? DateTime.Today;
        set
        {
            Report.FinalInfo.RepairedTest ??= new TesterInfo();
            Report.FinalInfo.RepairedTest.Date = value;
            OnPropertyChanged(nameof(DateRepaired));
        }
    }

    #endregion

    #region Final Test Properties

    public string? FinalTester
    {
        get => Report.FinalInfo.FinalTest?.Name;
        set
        {
            Report.FinalInfo.FinalTest ??= new TesterInfo();
            Report.FinalInfo.FinalTest.Name = value;
            OnPropertyChanged(nameof(FinalTester));
        }
    }

    public string? FinalTesterNo
    {
        get => Report.FinalInfo.FinalTest?.CertificationNo;
        set
        {
            Report.FinalInfo.FinalTest ??= new TesterInfo();
            Report.FinalInfo.FinalTest.CertificationNo = value;
            OnPropertyChanged(nameof(FinalTesterNo));
        }
    }

    public string? FinalTestKitSerial
    {
        get => Report.FinalInfo.FinalTest?.TestKitSerial;
        set
        {
            Report.FinalInfo.FinalTest ??= new TesterInfo();
            Report.FinalInfo.FinalTest.TestKitSerial = value;
            OnPropertyChanged(nameof(FinalTestKitSerial));
        }
    }

    public DateTime DatePassed
    {
        get => Report.FinalInfo.FinalTest?.Date ?? DateTime.Today;
        set
        {
            Report.FinalInfo.FinalTest ??= new TesterInfo();
            Report.FinalInfo.FinalTest.Date = value;
            OnPropertyChanged(nameof(DatePassed));
        }
    }

    #endregion

    #region Comments

    public string? Comments
    {
        get => Report.FinalInfo.Comments;
        set
        {
            Report.FinalInfo.Comments = value;
            OnPropertyChanged(nameof(Comments));
        }
    }

    #endregion

    #region Constructors

    public FinalViewModel(ReportData reportData) : base(reportData)
    {
        if (Report.RepairInfo?.WasRepaired ?? false) // Failed, Repaired, Passed
        {
            _showInitialFields = true;
            _showRepairedFields = true;
            _showPassedFields = true;
        }
        else if (Report.RepairInfo?.SkippedRepair ?? false) // Failed, Skipped Repair
        {
            _showInitialFields = true;
        }
        else // Passed
        {
            _showPassedFields = true;
        }
    }

    public FinalViewModel() : this(new ReportData())
    {
        Report.RepairInfo = new RepairInfo();
        Report.FinalInfo = new FinalInfo();
    }

    #endregion

    #region Navigation Methods

    protected override async Task OnNext()
    {
        if (ShowInitialFields && !await ValidateFailedBy()) return;
        if (ShowRepairedFields && !await ValidateRepairedBy()) return;
        if (ShowPassedFields && !await ValidatePassedBy()) return;

        await SaveReport();

        var serialNo = Report.DeviceInfo.Device.SerialNo;
        var fileName = $"{serialNo ?? "Unknown"}_{DateTime.Now:yyyy-M-d}.pdf";
        await ShareReportAsPdf(fileName);
    }

    protected override async Task OnBack()
    {
        await SaveReport();

        var type = Report.DeviceInfo.Device.Type;
        if (string.IsNullOrEmpty(type)) throw new InvalidDataException();

        BaseTestViewModel viewModel = type switch
        {
            "RP" => new RpTestViewModel(Report, !Report.RepairInfo?.WasRepaired ?? true),
            "DC" => new DcTestViewModel(Report, !Report.RepairInfo?.WasRepaired ?? true),
            "SC" => new ScTestViewModel(Report, !Report.RepairInfo?.WasRepaired ?? true),
            "PVB" => new PvbTestViewModel(Report, !Report.RepairInfo?.WasRepaired ?? true),
            "SVB" => new SvbTestViewModel(Report, !Report.RepairInfo?.WasRepaired ?? true),
            _ => throw new NotImplementedException($"The type '{type}' has not been implemented.")
        };

        var pageName = viewModel.GetType().Name.Replace("ViewModel", "");

        await Shell.Current.GoToAsync(pageName, new Dictionary<string, object>
        {
            { "ViewModel", viewModel }
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