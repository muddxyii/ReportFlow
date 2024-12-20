using System.Windows.Input;
using ReportFlow.Models;
using ReportFlow.Models.Repair;
using ReportFlow.ViewModels.FinalViewModels;
using ReportFlow.ViewModels.InfoViewModels;
using ReportFlow.ViewModels.TestViewModels;

namespace ReportFlow.ViewModels.RepairViewModels;

public class RepairViewModel : BaseBackflowViewModel
{
    #region Check1 Properties

    public bool Ck1Cleaned
    {
        get => Report.RepairInfo.Check1.Cleaned;
        set
        {
            Report.RepairInfo.Check1.Cleaned = value;
            OnPropertyChanged(nameof(Ck1Cleaned));
        }
    }

    public bool Ck1CheckDisc
    {
        get => Report.RepairInfo.Check1.CheckDisc;
        set
        {
            Report.RepairInfo.Check1.CheckDisc = value;
            OnPropertyChanged(nameof(Ck1CheckDisc));
        }
    }

    public bool Ck1DiscHolder
    {
        get => Report.RepairInfo.Check1.DiscHolder;
        set
        {
            Report.RepairInfo.Check1.DiscHolder = value;
            OnPropertyChanged(nameof(Ck1DiscHolder));
        }
    }

    public bool Ck1Spring
    {
        get => Report.RepairInfo.Check1.Spring;
        set
        {
            Report.RepairInfo.Check1.Spring = value;
            OnPropertyChanged(nameof(Ck1Spring));
        }
    }

    public bool Ck1Guide
    {
        get => Report.RepairInfo.Check1.Guide;
        set
        {
            Report.RepairInfo.Check1.Guide = value;
            OnPropertyChanged(nameof(Ck1Guide));
        }
    }

    public bool Ck1Seat
    {
        get => Report.RepairInfo.Check1.Seat;
        set
        {
            Report.RepairInfo.Check1.Seat = value;
            OnPropertyChanged(nameof(Ck1Seat));
        }
    }

    public bool Ck1Other
    {
        get => Report.RepairInfo.Check1.Other;
        set
        {
            Report.RepairInfo.Check1.Other = value;
            OnPropertyChanged(nameof(Ck1Other));
        }
    }

    #endregion

    #region Check2 Properties

    public bool Ck2Cleaned
    {
        get => Report.RepairInfo.Check2.Cleaned;
        set
        {
            Report.RepairInfo.Check2.Cleaned = value;
            OnPropertyChanged(nameof(Ck2Cleaned));
        }
    }

    public bool Ck2CheckDisc
    {
        get => Report.RepairInfo.Check2.CheckDisc;
        set
        {
            Report.RepairInfo.Check2.CheckDisc = value;
            OnPropertyChanged(nameof(Ck2CheckDisc));
        }
    }

    public bool Ck2DiscHolder
    {
        get => Report.RepairInfo.Check2.DiscHolder;
        set
        {
            Report.RepairInfo.Check2.DiscHolder = value;
            OnPropertyChanged(nameof(Ck2DiscHolder));
        }
    }

    public bool Ck2Spring
    {
        get => Report.RepairInfo.Check2.Spring;
        set
        {
            Report.RepairInfo.Check2.Spring = value;
            OnPropertyChanged(nameof(Ck2Spring));
        }
    }

    public bool Ck2Guide
    {
        get => Report.RepairInfo.Check2.Guide;
        set
        {
            Report.RepairInfo.Check2.Guide = value;
            OnPropertyChanged(nameof(Ck2Guide));
        }
    }

    public bool Ck2Seat
    {
        get => Report.RepairInfo.Check2.Seat;
        set
        {
            Report.RepairInfo.Check2.Seat = value;
            OnPropertyChanged(nameof(Ck2Seat));
        }
    }

    public bool Ck2Other
    {
        get => Report.RepairInfo.Check2.Other;
        set
        {
            Report.RepairInfo.Check2.Other = value;
            OnPropertyChanged(nameof(Ck2Other));
        }
    }

    #endregion

    #region RV Properties

    public bool RvCleaned
    {
        get => Report.RepairInfo.RV.Cleaned;
        set
        {
            Report.RepairInfo.RV.Cleaned = value;
            OnPropertyChanged(nameof(RvCleaned));
        }
    }

    public bool RvRubberKit
    {
        get => Report.RepairInfo.RV.RubberKit;
        set
        {
            Report.RepairInfo.RV.RubberKit = value;
            OnPropertyChanged(nameof(RvRubberKit));
        }
    }

    public bool RvDiscHolder
    {
        get => Report.RepairInfo.RV.DiscHolder;
        set
        {
            Report.RepairInfo.RV.DiscHolder = value;
            OnPropertyChanged(nameof(RvDiscHolder));
        }
    }

    public bool RvSpring
    {
        get => Report.RepairInfo.RV.Spring;
        set
        {
            Report.RepairInfo.RV.Spring = value;
            OnPropertyChanged(nameof(RvSpring));
        }
    }

    public bool RvGuide
    {
        get => Report.RepairInfo.RV.Guide;
        set
        {
            Report.RepairInfo.RV.Guide = value;
            OnPropertyChanged(nameof(RvGuide));
        }
    }

    public bool RvSeat
    {
        get => Report.RepairInfo.RV.Seat;
        set
        {
            Report.RepairInfo.RV.Seat = value;
            OnPropertyChanged(nameof(RvSeat));
        }
    }

    public bool RvOther
    {
        get => Report.RepairInfo.RV.Other;
        set
        {
            Report.RepairInfo.RV.Other = value;
            OnPropertyChanged(nameof(RvOther));
        }
    }

    #endregion

    #region PVB Properties

    public bool PvbCleaned
    {
        get => Report.RepairInfo.PVB.Cleaned;
        set
        {
            Report.RepairInfo.PVB.Cleaned = value;
            OnPropertyChanged(nameof(PvbCleaned));
        }
    }

    public bool PvbRubberKit
    {
        get => Report.RepairInfo.PVB.RubberKit;
        set
        {
            Report.RepairInfo.PVB.RubberKit = value;
            OnPropertyChanged(nameof(PvbRubberKit));
        }
    }

    public bool PvbDiscHolder
    {
        get => Report.RepairInfo.PVB.DiscHolder;
        set
        {
            Report.RepairInfo.PVB.DiscHolder = value;
            OnPropertyChanged(nameof(PvbDiscHolder));
        }
    }

    public bool PvbSpring
    {
        get => Report.RepairInfo.PVB.Spring;
        set
        {
            Report.RepairInfo.PVB.Spring = value;
            OnPropertyChanged(nameof(PvbSpring));
        }
    }

    public bool PvbGuide
    {
        get => Report.RepairInfo.PVB.Guide;
        set
        {
            Report.RepairInfo.PVB.Guide = value;
            OnPropertyChanged(nameof(PvbGuide));
        }
    }

    public bool PvbSeat
    {
        get => Report.RepairInfo.PVB.Seat;
        set
        {
            Report.RepairInfo.PVB.Seat = value;
            OnPropertyChanged(nameof(PvbSeat));
        }
    }

    public bool PvbOther
    {
        get => Report.RepairInfo.PVB.Other;
        set
        {
            Report.RepairInfo.PVB.Other = value;
            OnPropertyChanged(nameof(PvbOther));
        }
    }

    #endregion

    #region Commands

    public ICommand SkipCommand { get; }

    #endregion

    #region Constructors

    public RepairViewModel() : this(new ReportData())
    {
        Report.RepairInfo = new RepairInfo();
    }

    public RepairViewModel(ReportData reportData) : base(reportData)
    {
        SkipCommand = new Command(async () => await OnSkip());
    }

    #endregion

    #region Navigation Methods

    protected override async Task OnNext()
    {
        Report.RepairInfo.WasRepaired = true;

        await SaveReport();

        var type = Report.DeviceInfo.Device.Type;
        if (string.IsNullOrEmpty(type)) throw new InvalidDataException();

        BaseTestViewModel viewModel = type switch
        {
            "RP" => new RpTestViewModel(Report, false),
            "DC" => new DcTestViewModel(Report, false),
            "SC" => new ScTestViewModel(Report, false),
            "PVB" => new PvbTestViewModel(Report, false),
            "SVB" => new SvbTestViewModel(Report, false),
            _ => throw new NotImplementedException($"The type '{type}' has not been implemented.")
        };

        var pageName = viewModel.GetType().Name.Replace("ViewModel", "");

        await Shell.Current.GoToAsync(pageName, new Dictionary<string, object>
        {
            { "ViewModel", viewModel }
        });
    }

    protected override async Task OnBack()
    {
        await SaveReport();

        var type = Report.DeviceInfo.Device.Type;
        if (string.IsNullOrEmpty(type)) throw new InvalidDataException();

        BaseTestViewModel viewModel = type switch
        {
            "RP" => new RpTestViewModel(Report, true),
            "DC" => new DcTestViewModel(Report, true),
            "SC" => new ScTestViewModel(Report, true),
            "PVB" => new PvbTestViewModel(Report, true),
            "SVB" => new SvbTestViewModel(Report, true),
            _ => throw new NotImplementedException($"The type '{type}' has not been implemented.")
        };

        var pageName = viewModel.GetType().Name.Replace("ViewModel", "");
        var nav = "///MainPage/CustomerInfo/DeviceInfo/" + pageName;

        await Shell.Current.GoToAsync(nav, new Dictionary<string, object>
        {
            { "ViewModel", viewModel }
        });
    }

    protected async Task OnSkip()
    {
        Report.RepairInfo.SkippedRepair = true;

        var viewModel = new FinalViewModel(Report);
        await Shell.Current.GoToAsync("PassFinal", new Dictionary<string, object>
        {
            { "ViewModel", viewModel }
        });
    }

    #endregion
}