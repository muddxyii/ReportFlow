using ABFReportEditor.ViewModels.FinalViewModels;
using ABFReportEditor.ViewModels.RepairViewModels;

namespace ABFReportEditor.ViewModels.TestViewModels;

public abstract class BaseTestViewModel : BaseBackflowViewModel
{
    #region Dropdown Items
    
    #region ALl BF Dropdowns
    
    public List<string> ShutoffValveOptions { get; } =
    [
        "BOTH OK", "BOTH CLOSED", "BOTH VALVES",
        "#1 VALVE", "#2 VALVE"
    ];
    
    #endregion
    
    #endregion
    
    #region Private properties

    #region All BF Properties

    private string? _linePressure;
    private string? _shutoffValve;
    private string? _sovComment;

    #endregion
    
    #region Check Related Properties
    
    private string? _checkValve1;
    private string? _checkValve2;
    private bool _checkValve1Leaked;
    private bool _checkValve2Leaked;
    
    #endregion
    
    #region RV Related Properties
    
    private string? _pressureReliefOpening;
    private bool _reliefValveDidNotOpen;

    #endregion
    
    #region BaseTestViewModel
    
    Dictionary<string, string> _failedFieldsToSave = new Dictionary<string, string>();
    Dictionary<string, string> _passedFieldsToSave = new Dictionary<string, string>();
    
    #endregion
    
    #endregion
    
    #region Public Properties

    public string? LinePressure
    {
        get => _linePressure;
        set
        {
            _linePressure = value;
            _failedFieldsToSave["LinePressure"] = value ?? string.Empty;
            _passedFieldsToSave["LinePressure"] = value ?? string.Empty;
            OnPropertyChanged(nameof(LinePressure));
        }
    }
    
    public string? ShutoffValve
    {
        get => _shutoffValve;
        set
        {
            _shutoffValve = value;
            _failedFieldsToSave["SOVList"] = value ?? string.Empty;
            _passedFieldsToSave["SOVList"] = value ?? string.Empty;
            OnPropertyChanged(nameof(ShutoffValve));
        }
    }
    
    public string? SovComment
    {
        get => _sovComment;
        set
        {
            _sovComment = value;
            _failedFieldsToSave["SOVComment"] = value?.ToUpper() ?? string.Empty;
            _passedFieldsToSave["SOVComment"] = value?.ToUpper() ?? string.Empty;
            OnPropertyChanged(nameof(SovComment));
        }
    }

    public string? CheckValve1
    {
        get => _checkValve1;
        set
        {
            _checkValve1 = value;
            _failedFieldsToSave["InitialCT1"] = decimal.TryParse(CheckValve1, out decimal fcv1) ? fcv1.ToString("F1") : string.Empty;
            _passedFieldsToSave["FinalCT1"] = decimal.TryParse(CheckValve1, out decimal pcv1) ? pcv1.ToString("F1") : string.Empty;
            OnPropertyChanged(nameof(LinePressure));
        }
    }

    public string? CheckValve2
    {
        get => _checkValve2;
        set
        {
            _checkValve2 = value;
            _failedFieldsToSave["InitialCT2"] = decimal.TryParse(CheckValve2, out decimal fcv2) ? fcv2.ToString("F1") : string.Empty;
            _passedFieldsToSave["FinalCT2"] = decimal.TryParse(CheckValve2, out decimal pcv2) ? pcv2.ToString("F1") : string.Empty;
            OnPropertyChanged(nameof(_checkValve2));
        }
    }
    
    public bool CheckValve1Leaked
    {
        get => _checkValve1Leaked;
        set
        {
            _checkValve1Leaked = value;
            _failedFieldsToSave["InitialCT1Box"] = CheckValve1Leaked ? "Off" : "On";
            _failedFieldsToSave["InitialCT1Leaked"] = CheckValve1Leaked ? "On" : "Off";
            _passedFieldsToSave["FinalCT1Box"] = CheckValve1Leaked ? "Off" : "On";
            OnPropertyChanged(nameof(CheckValve1Leaked));
        }
    }

    public bool CheckValve2Leaked
    {
        get => _checkValve2Leaked;
        set
        {
            _checkValve2Leaked = value;
            _failedFieldsToSave["InitialCT2Box"] = CheckValve2Leaked ? "Off" : "On";
            _failedFieldsToSave["InitialCT2Leaked"] = CheckValve2Leaked ? "On" : "Off";
            _passedFieldsToSave["FinalCT2Box"] = CheckValve2Leaked ? "Off" : "On";
            OnPropertyChanged(nameof(CheckValve2Leaked));
        }
    }

    public string? PressureReliefOpening
    {
        get => _pressureReliefOpening;
        set
        {
            _pressureReliefOpening = value;
            _failedFieldsToSave["InitialPSIRV"] = decimal.TryParse(PressureReliefOpening, out decimal frv) ? frv.ToString("F1") : string.Empty;
            _passedFieldsToSave["FinalRV"] = decimal.TryParse(PressureReliefOpening, out decimal prv) ? prv.ToString("F1") : string.Empty;
            OnPropertyChanged(nameof(_pressureReliefOpening));
        }
    }
    
    public bool ReliefValveDidNotOpen
    {
        get => _reliefValveDidNotOpen;
        set
        {
            _reliefValveDidNotOpen = value;
            _failedFieldsToSave["InitialRVDidNotOpen"] = ReliefValveDidNotOpen ? "On" : "Off";
            OnPropertyChanged(nameof(ReliefValveDidNotOpen));
        }
    }

    #endregion

    #region Functions
    
    # region Implementations
    protected override void LoadFormFields(Dictionary<string, string> formFields)
    {
        // Init check valve leaked buttons as true
        CheckValve1Leaked = true;
        CheckValve2Leaked = true;
    }

    protected override async Task OnNext()
    {
        if (!ValidateFields()) return;
        if (IsBackflowPassing())
        {
            await HandlePassingTest();
        }
        else
        {
            await HandleFailingTest();
        }
    }

    private async Task HandlePassingTest()
    {
        // Save Form Data
        SaveFormData(_passedFieldsToSave);
        
        // Load 'PassFinalViewModel'
        var viewModel = new PassFinalViewModel();
        viewModel.LoadPdfData(PdfData ?? throw new InvalidOperationException(),
            FormData ?? throw new InvalidOperationException());
        
        await Shell.Current.GoToAsync("PassFinal", new Dictionary<string, object>
        {
            { "ViewModel", viewModel }
        });
    }

    private async Task HandleFailingTest()
    {
        // Save Form Data
        SaveFormData(_failedFieldsToSave);
        
        // Create 'RepairViewModel'
        var repairViewModel = new BaseRepairViewModel();
        repairViewModel.LoadPdfData(PdfData ?? throw new InvalidOperationException(),
            FormData ?? throw new InvalidOperationException());
        
        // Load 'RepairViewModel' Based On Type
        var type = FormData?.GetValueOrDefault("BFType");
        if (string.IsNullOrEmpty(type)) throw new InvalidDataException();
        
        switch (type)
        {
            case "RP":
                await Shell.Current.GoToAsync("RpRepair", new Dictionary<string, object>
                {
                    { "ViewModel", repairViewModel }
                });
                break;
            case "DC":
                await Application.Current.MainPage.DisplayAlert(
                    "Not Implemented",
                    $"The type '{type}' has not been implemented.",
                    "OK"
                );
                break;
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

    #endregion
    
    # region Abstract

    protected virtual bool ValidateFields()
    {
        if (string.IsNullOrEmpty(LinePressure) || string.IsNullOrEmpty(ShutoffValve)) return false;
        
        return true;
    }

    // TODO: Add shut off valve #2 checkstate
    protected abstract bool IsBackflowPassing();

    #endregion

    #endregion

}