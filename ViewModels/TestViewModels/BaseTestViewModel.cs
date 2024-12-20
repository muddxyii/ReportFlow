using ReportFlow.Models.Test;
using ReportFlow.ViewModels.FinalViewModels;
using ReportFlow.ViewModels.InfoViewModels;
using ReportFlow.ViewModels.RepairViewModels;

namespace ReportFlow.ViewModels.TestViewModels;

public abstract class BaseTestViewModel : BaseBackflowViewModel
{
    protected readonly TestInfo TestInfo;

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
        get => TestInfo.BackflowTest.LinePressure;
        set
        {
            TestInfo.BackflowTest.LinePressure = value;
            OnPropertyChanged(nameof(LinePressure));
        }
    }

    public string? ShutoffValve
    {
        get => TestInfo.BackflowTest.ShutoffValve;
        set
        {
            TestInfo.BackflowTest.ShutoffValve = value;
            OnPropertyChanged(nameof(ShutoffValve));
        }
    }

    public string? SovComment
    {
        get => TestInfo.BackflowTest.SovComment;
        set
        {
            TestInfo.BackflowTest.SovComment = value;
            OnPropertyChanged(nameof(SovComment));
        }
    }

    #endregion

    #region Check Valve Details

    public string? CheckValve1
    {
        get => TestInfo.CheckValves.Valve1;
        set
        {
            TestInfo.CheckValves.Valve1 = value;
            OnPropertyChanged(nameof(CheckValve1));
        }
    }

    public string? CheckValve2
    {
        get => TestInfo.CheckValves.Valve2;
        set
        {
            TestInfo.CheckValves.Valve2 = value;
            OnPropertyChanged(nameof(CheckValve2));
        }
    }

    public bool CheckValve1Ct
    {
        get => TestInfo.CheckValves.Valve1Ct;
        set
        {
            TestInfo.CheckValves.Valve1Ct = value;
            OnPropertyChanged(nameof(CheckValve1Ct));
        }
    }

    public bool CheckValve2Ct
    {
        get => TestInfo.CheckValves.Valve2Ct;
        set
        {
            TestInfo.CheckValves.Valve2Ct = value;
            OnPropertyChanged(nameof(CheckValve2Ct));
        }
    }

    #endregion

    #region Relief Valve Details

    public string? PressureReliefOpening
    {
        get => TestInfo.ReliefValve.PressureReliefOpening;
        set
        {
            TestInfo.ReliefValve.PressureReliefOpening = value;
            OnPropertyChanged(nameof(PressureReliefOpening));
        }
    }

    public bool ReliefValveDidNotOpen
    {
        get => TestInfo.ReliefValve.ReliefValveDidNotOpen;
        set
        {
            TestInfo.ReliefValve.ReliefValveDidNotOpen = value;
            OnPropertyChanged(nameof(ReliefValveDidNotOpen));
        }
    }

    public bool ReliefValveLeaking
    {
        get => TestInfo.ReliefValve.ReliefValveLeaking;
        set
        {
            TestInfo.ReliefValve.ReliefValveLeaking = value;
            OnPropertyChanged(nameof(ReliefValveLeaking));
        }
    }

    #endregion

    #region Pvb Details

    public string? BackPressure
    {
        get => TestInfo.Pvb.BackPressure;
        set
        {
            TestInfo.Pvb.BackPressure = value;
            OnPropertyChanged(nameof(BackPressure));
        }
    }

    public string? AirInletOpening
    {
        get => TestInfo.Pvb.AirInletOpening;
        set
        {
            TestInfo.Pvb.AirInletOpening = value;
            OnPropertyChanged(nameof(AirInletOpening));
        }
    }

    public bool AirInletLeaked
    {
        get => TestInfo.Pvb.AirInletLeaked;
        set
        {
            TestInfo.Pvb.AirInletLeaked = value;
            OnPropertyChanged(nameof(AirInletLeaked));
        }
    }

    public bool AirInletDidNotOpen
    {
        get => TestInfo.Pvb.AirInletDidNotOpen;
        set
        {
            TestInfo.Pvb.AirInletDidNotOpen = value;
            OnPropertyChanged(nameof(AirInletDidNotOpen));
        }
    }

    public string? CkPvb
    {
        get => TestInfo.Pvb.CkPvb;
        set
        {
            TestInfo.Pvb.CkPvb = value;
            OnPropertyChanged(nameof(CkPvb));
        }
    }

    public bool CkPvbLeaked
    {
        get => TestInfo.Pvb.CkPvbLeaked;
        set
        {
            TestInfo.Pvb.CkPvbLeaked = value;
            OnPropertyChanged(nameof(CkPvbLeaked));
        }
    }

    #endregion

    #region Constructor

    protected BaseTestViewModel() : this(new Dictionary<string, string>())
    {
    }

    protected BaseTestViewModel(Dictionary<string, string> formData) : base(formData)
    {
        TestInfo = TestInfo.FromFormFields(formData);
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
        var viewModel = new DeviceInfoViewModel(FormData);
        await Shell.Current.GoToAsync("DeviceInfo", new Dictionary<string, object>
        {
            ["ViewModel"] = viewModel
        });
    }

    private async Task HandlePassingTest()
    {
        await SaveFormDataWithCache(TestInfo.ToPassedFormFields());

        var viewModel = DeterminePassingViewModel();
        await Shell.Current.GoToAsync("PassFinal", new Dictionary<string, object>
        {
            { "ViewModel", viewModel }
        });
    }

    private FinalViewModel DeterminePassingViewModel()
    {
        var hadPreviousFailure = !string.IsNullOrEmpty(FormData?.GetValueOrDefault("InitialCT1")) ||
                                 !string.IsNullOrEmpty(FormData?.GetValueOrDefault("InitialAirInlet"));

        return hadPreviousFailure
            ? new FinalViewModel(FormData, true, true, true)
            : new FinalViewModel(FormData, false, false, true);
    }

    private async Task HandleFailingTest()
    {
        var hadPreviousFailure = !string.IsNullOrEmpty(FormData?.GetValueOrDefault("InitialCT1")) ||
                                 !string.IsNullOrEmpty(FormData?.GetValueOrDefault("InitialAirInlet"));

        if (hadPreviousFailure)
        {
            var overwrite = await Application.Current.MainPage.DisplayAlert(
                "Overwrite Initial Test?",
                "Do you want to overwrite the initial failed test and erase repair details?",
                "Yes", "No");

            if (overwrite)
            {
                // TODO: Add logic to erase initial test and repair details
                // RepairData.RepairInfo = new();
            }
            else
            {
                return;
            }
        }

        await SaveFormDataWithCache(TestInfo.ToFailedFormFields());

        var repairViewModel = new RepairViewModel(FormData);
        var type = FormData?.GetValueOrDefault("BFType");

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

    #endregion

    #region Abstract Methods

    protected virtual async Task<bool> ValidateFields()
    {
        return await AreFieldsValid([
            (LinePressure ?? "", "Line Pressure"),
            (ShutoffValve ?? "", "Shutoff Valve")
        ]);
    }

    protected abstract bool IsBackflowPassing();

    #endregion
}