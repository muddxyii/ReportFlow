using System.Windows.Input;
using ReportFlow.Models.Repair;
using ReportFlow.ViewModels.FinalViewModels;
using ReportFlow.ViewModels.InfoViewModels;
using ReportFlow.ViewModels.TestViewModels;

namespace ReportFlow.ViewModels.RepairViewModels;

public class RepairViewModel : BaseBackflowViewModel
{
    private RepairInfo _repairInfo;

    #region Check1 Properties

    public bool Ck1Cleaned
    {
        get => _repairInfo.Check1.Cleaned;
        set
        {
            _repairInfo.Check1.Cleaned = value;
            OnPropertyChanged(nameof(Ck1Cleaned));
        }
    }

    public bool Ck1CheckDisc
    {
        get => _repairInfo.Check1.CheckDisc;
        set
        {
            _repairInfo.Check1.CheckDisc = value;
            OnPropertyChanged(nameof(Ck1CheckDisc));
        }
    }

    public bool Ck1DiscHolder
    {
        get => _repairInfo.Check1.DiscHolder;
        set
        {
            _repairInfo.Check1.DiscHolder = value;
            OnPropertyChanged(nameof(Ck1DiscHolder));
        }
    }

    public bool Ck1Spring
    {
        get => _repairInfo.Check1.Spring;
        set
        {
            _repairInfo.Check1.Spring = value;
            OnPropertyChanged(nameof(Ck1Spring));
        }
    }

    public bool Ck1Guide
    {
        get => _repairInfo.Check1.Guide;
        set
        {
            _repairInfo.Check1.Guide = value;
            OnPropertyChanged(nameof(Ck1Guide));
        }
    }

    public bool Ck1Seat
    {
        get => _repairInfo.Check1.Seat;
        set
        {
            _repairInfo.Check1.Seat = value;
            OnPropertyChanged(nameof(Ck1Seat));
        }
    }

    public bool Ck1Other
    {
        get => _repairInfo.Check1.Other;
        set
        {
            _repairInfo.Check1.Other = value;
            OnPropertyChanged(nameof(Ck1Other));
        }
    }

    #endregion

    #region Check2 Properties

    public bool Ck2Cleaned
    {
        get => _repairInfo.Check2.Cleaned;
        set
        {
            _repairInfo.Check2.Cleaned = value;
            OnPropertyChanged(nameof(Ck2Cleaned));
        }
    }

    public bool Ck2CheckDisc
    {
        get => _repairInfo.Check2.CheckDisc;
        set
        {
            _repairInfo.Check2.CheckDisc = value;
            OnPropertyChanged(nameof(Ck2CheckDisc));
        }
    }

    public bool Ck2DiscHolder
    {
        get => _repairInfo.Check2.DiscHolder;
        set
        {
            _repairInfo.Check2.DiscHolder = value;
            OnPropertyChanged(nameof(Ck2DiscHolder));
        }
    }

    public bool Ck2Spring
    {
        get => _repairInfo.Check2.Spring;
        set
        {
            _repairInfo.Check2.Spring = value;
            OnPropertyChanged(nameof(Ck2Spring));
        }
    }

    public bool Ck2Guide
    {
        get => _repairInfo.Check2.Guide;
        set
        {
            _repairInfo.Check2.Guide = value;
            OnPropertyChanged(nameof(Ck2Guide));
        }
    }

    public bool Ck2Seat
    {
        get => _repairInfo.Check2.Seat;
        set
        {
            _repairInfo.Check2.Seat = value;
            OnPropertyChanged(nameof(Ck2Seat));
        }
    }

    public bool Ck2Other
    {
        get => _repairInfo.Check2.Other;
        set
        {
            _repairInfo.Check2.Other = value;
            OnPropertyChanged(nameof(Ck2Other));
        }
    }

    #endregion

    #region RV Properties

    public bool RvCleaned
    {
        get => _repairInfo.RV.Cleaned;
        set
        {
            _repairInfo.RV.Cleaned = value;
            OnPropertyChanged(nameof(RvCleaned));
        }
    }

    public bool RvRubberKit
    {
        get => _repairInfo.RV.RubberKit;
        set
        {
            _repairInfo.RV.RubberKit = value;
            OnPropertyChanged(nameof(RvRubberKit));
        }
    }

    public bool RvDiscHolder
    {
        get => _repairInfo.RV.DiscHolder;
        set
        {
            _repairInfo.RV.DiscHolder = value;
            OnPropertyChanged(nameof(RvDiscHolder));
        }
    }

    public bool RvSpring
    {
        get => _repairInfo.RV.Spring;
        set
        {
            _repairInfo.RV.Spring = value;
            OnPropertyChanged(nameof(RvSpring));
        }
    }

    public bool RvGuide
    {
        get => _repairInfo.RV.Guide;
        set
        {
            _repairInfo.RV.Guide = value;
            OnPropertyChanged(nameof(RvGuide));
        }
    }

    public bool RvSeat
    {
        get => _repairInfo.RV.Seat;
        set
        {
            _repairInfo.RV.Seat = value;
            OnPropertyChanged(nameof(RvSeat));
        }
    }

    public bool RvOther
    {
        get => _repairInfo.RV.Other;
        set
        {
            _repairInfo.RV.Other = value;
            OnPropertyChanged(nameof(RvOther));
        }
    }

    #endregion

    #region PVB Properties

    public bool PvbCleaned
    {
        get => _repairInfo.PVB.Cleaned;
        set
        {
            _repairInfo.PVB.Cleaned = value;
            OnPropertyChanged(nameof(PvbCleaned));
        }
    }

    public bool PvbRubberKit
    {
        get => _repairInfo.PVB.RubberKit;
        set
        {
            _repairInfo.PVB.RubberKit = value;
            OnPropertyChanged(nameof(PvbRubberKit));
        }
    }

    public bool PvbDiscHolder
    {
        get => _repairInfo.PVB.DiscHolder;
        set
        {
            _repairInfo.PVB.DiscHolder = value;
            OnPropertyChanged(nameof(PvbDiscHolder));
        }
    }

    public bool PvbSpring
    {
        get => _repairInfo.PVB.Spring;
        set
        {
            _repairInfo.PVB.Spring = value;
            OnPropertyChanged(nameof(PvbSpring));
        }
    }

    public bool PvbGuide
    {
        get => _repairInfo.PVB.Guide;
        set
        {
            _repairInfo.PVB.Guide = value;
            OnPropertyChanged(nameof(PvbGuide));
        }
    }

    public bool PvbSeat
    {
        get => _repairInfo.PVB.Seat;
        set
        {
            _repairInfo.PVB.Seat = value;
            OnPropertyChanged(nameof(PvbSeat));
        }
    }

    public bool PvbOther
    {
        get => _repairInfo.PVB.Other;
        set
        {
            _repairInfo.PVB.Other = value;
            OnPropertyChanged(nameof(PvbOther));
        }
    }

    #endregion

    #region Commands

    public ICommand SkipCommand { get; }

    #endregion

    #region Constructors

    public RepairViewModel() : this(new Dictionary<string, string>())
    {
    }

    public RepairViewModel(Dictionary<string, string> formData) : base(formData)
    {
        _repairInfo = RepairInfo.FromFormFields(formData);
        SkipCommand = new Command(async () => await OnSkip());
    }

    #endregion

    #region Navigation Methods

    protected override async Task OnNext()
    {
        await SaveFormDataWithCache(_repairInfo.ToFormFields());

        var type = FormData.GetValueOrDefault("BFType")?.ToString();
        if (string.IsNullOrEmpty(type)) throw new InvalidDataException();

        BaseTestViewModel viewModel = type switch
        {
            "RP" => new RpTestViewModel(FormData),
            "DC" => new DcTestViewModel(FormData),
            "SC" => new ScTestViewModel(FormData),
            "PVB" => new PvbTestViewModel(FormData),
            "SVB" => new SvbTestViewModel(FormData),
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
        await SaveFormDataWithCache(_repairInfo.ToFormFields());
        var viewModel = new DeviceInfoViewModel(FormData);
        await Shell.Current.GoToAsync("DeviceInfo", new Dictionary<string, object>
        {
            ["ViewModel"] = viewModel
        });
    }

    protected async Task OnSkip()
    {
        var viewModel = new FinalViewModel(FormData, true, false, false);
        await Shell.Current.GoToAsync("PassFinal", new Dictionary<string, object>
        {
            { "ViewModel", viewModel }
        });
    }

    #endregion
}