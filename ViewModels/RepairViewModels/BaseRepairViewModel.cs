using System.Windows.Input;
using ReportFlow.ViewModels.FinalViewModels;
using ReportFlow.ViewModels.TestViewModels;

namespace ReportFlow.ViewModels.RepairViewModels;

public class BaseRepairViewModel: BaseBackflowViewModel
{
    #region Private properties
    
    #region Check Related Properties
    
    private bool _ck1Cleaned;
    private bool _ck2Cleaned;
    private bool _ck1CheckDisc;
    private bool _ck2CheckDisc;
    private bool _ck1DiscHolder;
    private bool _ck2DiscHolder;
    private bool _ck1Spring;
    private bool _ck2Spring;
    private bool _ck1Guide;
    private bool _ck2Guide;
    private bool _ck1Seat;
    private bool _ck2Seat;
    private bool _ck1Other;
    private bool _ck2Other;
    
    #endregion
    
    #region RV Related Properties
    
    private bool _rvCleaned;
    private bool _rvRubberKit;
    private bool _rvDiscHolder;
    private bool _rvSpring;
    private bool _rvGuide;
    private bool _rvSeat;
    private bool _rvOther;

    #endregion
    
    #region PVB Related Properties
    
    private bool _pvbCleaned;
    private bool _pvbRubberKit;
    private bool _pvbDiscHolder;
    private bool _pvbSpring;
    private bool _pvbGuide;
    private bool _pvbSeat;
    private bool _pvbOther;
    
    #endregion
    
    #region BaseRepairViewModel
    
    Dictionary<string, string> _fieldsToSave = new Dictionary<string, string>();
    
    #endregion
    
    #endregion
    
    #region Public properties
    
    #region Check Related Properties
    
    public bool Ck1Cleaned
    {
        get => _ck1Cleaned;
        set
        {
            _ck1Cleaned = value;
            _fieldsToSave["Ck1Cleaned"] = _ck1Cleaned ? "On" : "Off";
            OnPropertyChanged(nameof(Ck1Cleaned));
        }
    }
    
    public bool Ck2Cleaned
    {
        get => _ck2Cleaned;
        set
        {
            _ck2Cleaned = value;
            _fieldsToSave["Ck2Cleaned"] = _ck2Cleaned ? "On" : "Off";
            OnPropertyChanged(nameof(Ck2Cleaned));
        }
    }

    public bool Ck1CheckDisc
    {
        get => _ck1CheckDisc;
        set
        {
            _ck1CheckDisc = value;
            _fieldsToSave["Ck1CheckDisc"] = _ck1CheckDisc ? "On" : "Off";
            OnPropertyChanged(nameof(Ck1CheckDisc));
        }
    }

    public bool Ck2CheckDisc
    {
        get => _ck2CheckDisc;
        set
        {
            _ck2CheckDisc = value;
            _fieldsToSave["Ck2CheckDisc"] = _ck2CheckDisc ? "On" : "Off";
            OnPropertyChanged(nameof(Ck2CheckDisc));
        }
    }

    public bool Ck1DiscHolder
    {
        get => _ck1DiscHolder;
        set
        {
            _ck1DiscHolder = value;
            _fieldsToSave["Ck1DiscHolder"] = _ck1DiscHolder ? "On" : "Off";
            OnPropertyChanged(nameof(Ck1DiscHolder));
        }
    }

    public bool Ck2DiscHolder
    {
        get => _ck2DiscHolder;
        set
        {
            _ck2DiscHolder = value;
            _fieldsToSave["Ck2DiscHolder"] = _ck2DiscHolder ? "On" : "Off";
            OnPropertyChanged(nameof(Ck2DiscHolder));
        }
    }

    public bool Ck1Spring
    {
        get => _ck1Spring;
        set
        {
            _ck1Spring = value;
            _fieldsToSave["Ck1Spring"] = _ck1Spring ? "On" : "Off";
            OnPropertyChanged(nameof(Ck1Spring));
        }
    }

    public bool Ck2Spring
    {
        get => _ck2Spring;
        set
        {
            _ck2Spring = value;
            _fieldsToSave["Ck2Spring"] = _ck2Spring ? "On" : "Off";
            OnPropertyChanged(nameof(Ck2Spring));
        }
    }

    public bool Ck1Guide
    {
        get => _ck1Guide;
        set
        {
            _ck1Guide = value;
            _fieldsToSave["Ck1Guide"] = _ck1Guide ? "On" : "Off";
            OnPropertyChanged(nameof(Ck1Guide));
        }
    }

    public bool Ck2Guide
    {
        get => _ck2Guide;
        set
        {
            _ck2Guide = value;
            _fieldsToSave["Ck2Guide"] = _ck2Guide ? "On" : "Off";
            OnPropertyChanged(nameof(Ck2Guide));
        }
    }

    public bool Ck1Seat
    {
        get => _ck1Seat;
        set
        {
            _ck1Seat = value;
            _fieldsToSave["Ck1Seat"] = _ck1Seat ? "On" : "Off";
            OnPropertyChanged(nameof(Ck1Seat));
        }
    }

    public bool Ck2Seat
    {
        get => _ck2Seat;
        set
        {
            _ck2Seat = value;
            _fieldsToSave["Ck2Seat"] = _ck2Seat ? "On" : "Off";
            OnPropertyChanged(nameof(Ck2Seat));
        }
    }

    public bool Ck1Other
    {
        get => _ck1Other;
        set
        {
            _ck1Other = value;
            _fieldsToSave["Ck1Other"] = _ck1Other ? "On" : "Off";
            OnPropertyChanged(nameof(Ck1Other));
        }
    }

    public bool Ck2Other
    {
        get => _ck2Other;
        set
        {
            _ck2Other = value;
            _fieldsToSave["Ck2Other"] = _ck2Other ? "On" : "Off";
            OnPropertyChanged(nameof(Ck2Other));
        }
    }
    
    #endregion
    
    #region RV Related Properties

    public bool RvCleaned
    {
        get => _rvCleaned;
        set
        {
            _rvCleaned = value;
            _fieldsToSave["RVCleaned"] = _rvCleaned ? "On" : "Off";
            OnPropertyChanged(nameof(RvCleaned));
        }
    }

    public bool RvRubberKit
    {
        get => _rvRubberKit;
        set
        {
            _rvRubberKit = value;
            _fieldsToSave["RVRubberKit"] = _rvRubberKit ? "On" : "Off";
            OnPropertyChanged(nameof(RvRubberKit));
        }
    }

    public bool RvDiscHolder
    {
        get => _rvDiscHolder;
        set
        {
            _rvDiscHolder = value;
            _fieldsToSave["RVDiscHolder"] = _rvDiscHolder ? "On" : "Off";
            OnPropertyChanged(nameof(RvDiscHolder));
        }
    }

    public bool RvSpring
    {
        get => _rvSpring;
        set
        {
            _rvSpring = value;
            _fieldsToSave["RVSpring"] = _rvSpring ? "On" : "Off";
            OnPropertyChanged(nameof(RvSpring));
        }
    }

    public bool RvGuide
    {
        get => _rvGuide;
        set
        {
            _rvGuide = value;
            _fieldsToSave["RVGuide"] = _rvGuide ? "On" : "Off";
            OnPropertyChanged(nameof(RvGuide));
        }
    }

    public bool RvSeat
    {
        get => _rvSeat;
        set
        {
            _rvSeat = value;
            _fieldsToSave["RVSeat"] = _rvSeat ? "On" : "Off";
            OnPropertyChanged(nameof(RvSeat));
        }
    }

    public bool RvOther
    {
        get => _rvOther;
        set
        {
            _rvOther = value;
            _fieldsToSave["RVOther"] = _rvOther ? "On" : "Off";
            OnPropertyChanged(nameof(RvOther));
        }
    }

    #endregion
    
    #region PVB Related Properties

    public bool PvbCleaned
    {
        get => _pvbCleaned;
        set
        {
            _pvbCleaned = value;
            _fieldsToSave["PVBCleaned"] = _pvbCleaned ? "On" : "Off";
            OnPropertyChanged(nameof(PvbCleaned));
        }
    }

    public bool PvbRubberKit
    {
        get => _pvbRubberKit;
        set
        {
            _pvbRubberKit = value;
            _fieldsToSave["PVBRubberKit"] = _pvbRubberKit ? "On" : "Off";
            OnPropertyChanged(nameof(PvbRubberKit));
        }
    }

    public bool PvbDiscHolder
    {
        get => _pvbDiscHolder;
        set
        {
            _pvbDiscHolder = value;
            _fieldsToSave["PVBDiscHolder"] = _pvbDiscHolder ? "On" : "Off";
            OnPropertyChanged(nameof(PvbDiscHolder));
        }
    }

    public bool PvbSpring
    {
        get => _pvbSpring;
        set
        {
            _pvbSpring = value;
            _fieldsToSave["PVBSpring"] = _pvbSpring ? "On" : "Off";
            OnPropertyChanged(nameof(PvbSpring));
        }
    }

    public bool PvbGuide
    {
        get => _pvbGuide;
        set
        {
            _pvbGuide = value;
            _fieldsToSave["PVBGuide"] = _pvbGuide ? "On" : "Off";
            OnPropertyChanged(nameof(PvbGuide));
        }
    }

    public bool PvbSeat
    {
        get => _pvbSeat;
        set
        {
            _pvbSeat = value;
            _fieldsToSave["PVBSeat"] = _pvbSeat ? "On" : "Off";
            OnPropertyChanged(nameof(PvbSeat));
        }
    }

    public bool PvbOther
    {
        get => _pvbOther;
        set
        {
            _pvbOther = value;
            _fieldsToSave["PVBOther"] = _pvbOther ? "On" : "Off";
            OnPropertyChanged(nameof(PvbOther));
        }
    }

    #endregion
    
    #endregion
    
    #region Functions
    
    #region Implementations 
    public ICommand SkipCommand { get; }

    public BaseRepairViewModel() : base(new Dictionary<string, string>())
    {
        SkipCommand = new Command(async () => await OnSkip());
    }
    
    public BaseRepairViewModel(Dictionary<string, string>? formData) : base(formData)
    {
        SkipCommand = new Command(async () => await OnSkip());
    }

    #endregion
    
    protected override async Task OnNext()
    {
        // Save Form Data
        await SaveFormDataWithCache(_fieldsToSave);
        
        // Load 'TestViewModel' Based On Type
        var type = FormData?.GetValueOrDefault("BFType");
        if (string.IsNullOrEmpty(type)) throw new InvalidDataException();

        switch (type)
        {
            case "RP":
                var rpViewModel = new RpTestViewModel(FormData);
                await Shell.Current.GoToAsync("RpTest", new Dictionary<string, object>
                {
                    { "ViewModel", rpViewModel }
                });
                break;
            case "DC":
                var dcViewModel = new DcTestViewModel(FormData);
                await Shell.Current.GoToAsync("DcTest", new Dictionary<string, object>
                {
                    { "ViewModel", dcViewModel }
                });
                break;
            case "SC":
                var scViewModel = new ScTestViewModel(FormData);
                await Shell.Current.GoToAsync("ScTest", new Dictionary<string, object>
                {
                    { "ViewModel", scViewModel }
                });
                break;
            case "PVB":
                var pvbViewModel = new PvbTestViewModel(FormData);
                await Shell.Current.GoToAsync("PvbTest", new Dictionary<string, object>
                {
                    { "ViewModel", pvbViewModel }
                });
                break;
            case "SVB":
                var svbViewModel = new SvbTestViewModel(FormData);
                await Shell.Current.GoToAsync("SvbTest", new Dictionary<string, object>
                {
                    { "ViewModel", svbViewModel }
                });
                break;
            default:
                await Application.Current.MainPage.DisplayAlert(
                    "Not Implemented",
                    $"The type '{type}' has not been implemented.",
                    "OK"
                );
                break;
        }
    }
    
    protected async Task OnSkip()
    {
        // Load 'PassFinalViewModel'
        var viewModel = new PassFinalViewModel(FormData,
            true, false, false);
        await Shell.Current.GoToAsync("PassFinal", new Dictionary<string, object>
        {
            { "ViewModel", viewModel }
        });
    }
    
    #endregion
}