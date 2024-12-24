using ReportFlow.Models;
using ReportFlow.Models.Repair;
using ReportFlow.Models.Test;
using ReportFlow.ViewModels.FinalViewModels;
using ReportFlow.ViewModels.InfoViewModels;
using ReportFlow.ViewModels.RepairViewModels;

namespace ReportFlow.ViewModels.TestViewModels;

public abstract class BaseTestViewModel : BaseBackflowViewModel
{
    private readonly TestInfo _testInfo;
    public bool IsInitialTest { get; }

    #region Dropdown Items

    public List<string> ShutoffValveOptions { get; } =
    [
        "BOTH OK", "BOTH CLOSED", "BOTH VALVES",
        "#1 VALVE", "#2 VALVE"
    ];

    public List<string> BackPressureOptions { get; } =
    [
        "NO", "YES"
    ];

    #endregion

    #region Backflow Test Details

    public string? LinePressure
    {
        get => _testInfo?.BackflowTest.LinePressure;
        set
        {
            _testInfo.BackflowTest.LinePressure = value;
            OnPropertyChanged(nameof(LinePressure));
        }
    }

    public string? ShutoffValve
    {
        get => _testInfo?.BackflowTest.ShutoffValve;
        set
        {
            _testInfo.BackflowTest.ShutoffValve = value;
            OnPropertyChanged(nameof(ShutoffValve));
        }
    }

    public string? SovComment
    {
        get => _testInfo?.BackflowTest.SovComment;
        set
        {
            _testInfo.BackflowTest.SovComment = value;
            OnPropertyChanged(nameof(SovComment));
        }
    }

    #endregion

    #region Check Valve Details

    public string? CheckValve1
    {
        get => _testInfo?.CheckValves.Valve1;
        set
        {
            _testInfo.CheckValves.Valve1 = value;
            OnPropertyChanged(nameof(CheckValve1));
        }
    }

    public string? CheckValve2
    {
        get => _testInfo?.CheckValves.Valve2;
        set
        {
            _testInfo.CheckValves.Valve2 = value;
            OnPropertyChanged(nameof(CheckValve2));
        }
    }

    public bool CheckValve1Ct
    {
        get => _testInfo?.CheckValves.Valve1Ct ?? false;
        set
        {
            _testInfo.CheckValves.Valve1Ct = value;
            OnPropertyChanged(nameof(CheckValve1Ct));
        }
    }

    public bool CheckValve2Ct
    {
        get => _testInfo?.CheckValves.Valve2Ct ?? false;
        set
        {
            _testInfo.CheckValves.Valve2Ct = value;
            OnPropertyChanged(nameof(CheckValve2Ct));
        }
    }

    #endregion

    #region Relief Valve Details

    public string? PressureReliefOpening
    {
        get => _testInfo?.ReliefValve.PressureReliefOpening;
        set
        {
            _testInfo.ReliefValve.PressureReliefOpening = value;
            OnPropertyChanged(nameof(PressureReliefOpening));
        }
    }

    public bool ReliefValveDidNotOpen
    {
        get => _testInfo?.ReliefValve.ReliefValveDidNotOpen ?? false;
        set
        {
            _testInfo.ReliefValve.ReliefValveDidNotOpen = value;
            OnPropertyChanged(nameof(ReliefValveDidNotOpen));
        }
    }

    public bool ReliefValveLeaking
    {
        get => _testInfo?.ReliefValve.ReliefValveLeaking ?? false;
        set
        {
            _testInfo.ReliefValve.ReliefValveLeaking = value;
            OnPropertyChanged(nameof(ReliefValveLeaking));
        }
    }

    #endregion

    #region Pvb Details

    public string? BackPressure
    {
        get => _testInfo?.Pvb.BackPressure;
        set
        {
            _testInfo.Pvb.BackPressure = value;
            OnPropertyChanged(nameof(BackPressure));
        }
    }

    public string? AirInletOpening
    {
        get => _testInfo?.Pvb.AirInletOpening;
        set
        {
            _testInfo.Pvb.AirInletOpening = value;
            OnPropertyChanged(nameof(AirInletOpening));
        }
    }

    public bool AirInletLeaked
    {
        get => _testInfo?.Pvb.AirInletLeaked ?? false;
        set
        {
            _testInfo.Pvb.AirInletLeaked = value;
            OnPropertyChanged(nameof(AirInletLeaked));
        }
    }

    public bool AirInletDidNotOpen
    {
        get => _testInfo?.Pvb.AirInletDidNotOpen ?? false;
        set
        {
            _testInfo.Pvb.AirInletDidNotOpen = value;
            OnPropertyChanged(nameof(AirInletDidNotOpen));
        }
    }

    public string? CkPvb
    {
        get => _testInfo?.Pvb.CkPvb;
        set
        {
            _testInfo.Pvb.CkPvb = value;
            OnPropertyChanged(nameof(CkPvb));
        }
    }

    public bool CkPvbLeaked
    {
        get => _testInfo?.Pvb.CkPvbLeaked ?? false;
        set
        {
            _testInfo.Pvb.CkPvbLeaked = value;
            OnPropertyChanged(nameof(CkPvbLeaked));
        }
    }

    #endregion

    #region Constructor

    protected BaseTestViewModel() : this(new ReportData(), true)
    {
        _testInfo = new TestInfo("");
    }

    protected BaseTestViewModel(ReportData reportData, bool isInitialTest) : base(reportData)
    {
        IsInitialTest = isInitialTest;

        if (reportData.DeviceInfo != null)
        {
            var type = reportData.DeviceInfo.Device.Type;
            _testInfo = IsInitialTest
                ? reportData.InitialTest ?? new TestInfo(type)
                : reportData.FinalTest ?? new TestInfo(type);
        }
    }

    #endregion

    #region Navigation Methods

    protected override async Task OnNext()
    {
        if (!await ValidateFields()) return;

        if (IsBackflowPassing())
            await HandlePassingTest();
        else
            await HandleFailingTest();
    }

    protected override async Task OnBack()
    {
        if (IsInitialTest)
        {
            Report.InitialTest = _testInfo;

            await SaveReport();
            var viewModel = new DeviceInfoViewModel(Report);
            await Shell.Current.GoToAsync("///MainPage/CustomerInfo/DeviceInfo", new Dictionary<string, object>
            {
                ["ViewModel"] = viewModel
            });
        }
        else
        {
            Report.FinalTest = _testInfo;

            await SaveReport();

            var repairViewModel = new RepairViewModel(Report);
            var type = Report.DeviceInfo.Device.Type;

            if (string.IsNullOrEmpty(type))
                throw new InvalidDataException("Backflow type is required");

            var repairRoute = DetermineRepairRoute(type);
            var testRoute = DetermineTestRoute(type);
            var nav = "///MainPage/CustomerInfo/DeviceInfo/" + testRoute + "/" + repairRoute;
            await Shell.Current.GoToAsync(nav, new Dictionary<string, object>
            {
                { "ViewModel", repairViewModel }
            });
        }
    }

    private async Task HandlePassingTest()
    {
        // Assign TestInfo
        if (IsInitialTest)
        {
            Report.InitialTest = _testInfo;
            Report.RepairInfo = new RepairInfo();
        }
        else
        {
            Report.FinalTest = _testInfo;
        }

        await SaveReport();

        var viewModel = new FinalViewModel(Report);
        await Shell.Current.GoToAsync("PassFinal", new Dictionary<string, object>
        {
            { "ViewModel", viewModel }
        });
    }


    private async Task HandleFailingTest()
    {
        if (!IsInitialTest)
        {
            var overwrite = await Application.Current.MainPage.DisplayAlert(
                "Overwrite Initial Test",
                "Do you want to overwrite the initial failed test and erase repair details?",
                "Overwrite", "Cancel");

            if (overwrite)
            {
                Report.InitialTest = _testInfo;
                Report.FinalTest = new TestInfo(_testInfo.BackflowType);
                Report.RepairInfo = new RepairInfo();
            }
            else
            {
                return;
            }
        }
        else
        {
            Report.InitialTest = _testInfo;
        }

        await SaveReport();

        var repairViewModel = new RepairViewModel(Report);
        var type = Report.DeviceInfo.Device.Type;

        if (string.IsNullOrEmpty(type))
            throw new InvalidDataException("Backflow type is required");

        var route = DetermineRepairRoute(type);
        await Shell.Current.GoToAsync(route, new Dictionary<string, object>
        {
            { "ViewModel", repairViewModel }
        });
    }

    private static string DetermineRepairRoute(string type)
    {
        return type switch
        {
            "RP" => "RpRepair",
            "DC" => "DcRepair",
            "SC" => "ScRepair",
            "PVB" => "PvbRepair",
            "SVB" => "SvbRepair",
            _ => throw new InvalidDataException($"The type '{type}' has not been implemented.")
        };
    }

    private static string DetermineTestRoute(string type)
    {
        return type switch
        {
            "RP" => "RpTest",
            "DC" => "DcTest",
            "SC" => "ScTest",
            "PVB" => "PvbTest",
            "SVB" => "SvbTest",
            _ => throw new InvalidDataException($"The type '{type}' has not been implemented.")
        };
    }

    #endregion

    #region Abstract Methods

    protected virtual async Task<bool> ValidateFields()
    {
        // Only validate on initial test
        if (!IsInitialTest) return true;
        return await AreFieldsValid([
            (LinePressure ?? "", "Line Pressure"),
            (ShutoffValve ?? "", "Shutoff Valve")
        ]);
    }

    protected abstract bool IsBackflowPassing();

    #endregion
}