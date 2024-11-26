using ABFReportEditor.ViewModels.FinalViewModels;

namespace ABFReportEditor.ViewModels.TestViewModels;

public class RpTestViewModel : BaseBackflowViewModel
{
    #region Dropdown Items

    public List<string> ShutoffValveOptions { get; } =
    [
        "BOTH OK", "BOTH CLOSED", "BOTH VALVES",
        "#1 VALVE", "#2 VALVE"
    ];

    #endregion

    #region Private properties

    private string? _linePressure;
    private string? _shutoffValve;
    private string? _sovComment;
    private string? _checkValve1;
    private string? _checkValve2;
    private string? _pressureReliefOpening;
    private bool _checkValve1Leaked;
    private bool _checkValve2Leaked;
    private bool _reliefValveDidNotOpen;

    #endregion

    #region Public Properties

    public string? LinePressure
    {
        get => _linePressure;
        set
        {
            _linePressure = value;
            OnPropertyChanged(nameof(LinePressure));
        }
    }
    
    public string? ShutoffValve
    {
        get => _shutoffValve;
        set
        {
            _shutoffValve = value;
            OnPropertyChanged(nameof(ShutoffValve));
        }
    }
    
    public string? SOVComment
    {
        get => _sovComment;
        set
        {
            _sovComment = value;
            OnPropertyChanged(nameof(SOVComment));
        }
    }

    public string? CheckValve1
    {
        get => _checkValve1;
        set
        {
            _checkValve1 = value;
            OnPropertyChanged(nameof(LinePressure));
        }
    }

    public string? CheckValve2
    {
        get => _checkValve2;
        set
        {
            _checkValve2 = value;
            OnPropertyChanged(nameof(_checkValve2));
        }
    }

    public string? PressureReliefOpening
    {
        get => _pressureReliefOpening;
        set
        {
            _pressureReliefOpening = value;
            OnPropertyChanged(nameof(_pressureReliefOpening));
        }
    }

    public bool CheckValve1Leaked
    {
        get => _checkValve1Leaked;
        set
        {
            _checkValve1Leaked = value;
            OnPropertyChanged(nameof(CheckValve1Leaked));
        }
    }

    public bool CheckValve2Leaked
    {
        get => _checkValve2Leaked;
        set
        {
            _checkValve2Leaked = value;
            OnPropertyChanged(nameof(CheckValve2Leaked));
        }
    }

    public bool ReliefValveDidNotOpen
    {
        get => _reliefValveDidNotOpen;
        set
        {
            _reliefValveDidNotOpen = value;
            OnPropertyChanged(nameof(ReliefValveDidNotOpen));
        }
    }

    #endregion

    #region Abstract function implementation

    protected override void LoadFormFields(Dictionary<string, string> formFields)
    {
        // Init check valve leaked buttons as true
        CheckValve1Leaked = true;
        CheckValve2Leaked = true;
    }

    protected override async Task OnNext()
    {
        // List of required fields with their error message
        var requiredFields = new Dictionary<string, string>
        {
            { nameof(LinePressure), "Line Pressure" },
            { nameof(ShutoffValve), "SOV Status" },
            { nameof(CheckValve1), "CV1 Value" },
            { nameof(PressureReliefOpening), "RV Opening Value" }
        };

        // Check string fields
        foreach (var field in requiredFields)
        {
            var propertyValue = GetType().GetProperty(field.Key)?.GetValue(this) as string;
            if (string.IsNullOrEmpty(propertyValue))
            {
                await Application.Current.MainPage.DisplayAlert(
                    "Fields are empty",
                    $"Error: '{field.Value}'",
                    "OK"
                );
                return;
            }
        }

        // Check if backflow passed or not
        if (IsBackflowPassing())
        {
            // Save form data
            Dictionary<string, string> formFields = new Dictionary<string, string>()
            {
                { "LinePressure", LinePressure ?? string.Empty },
                { "SOVList", ShutoffValve ?? string.Empty },
                { "SOVComment", SOVComment?.ToUpper() ?? string.Empty },
                { "FinalCT1", decimal.TryParse(CheckValve1, out decimal cv1) ? cv1.ToString("F1") : string.Empty },
                { "FinalCT2", decimal.TryParse(CheckValve2, out decimal cv2) ? cv2.ToString("F1") : string.Empty },
                { "FinalRV", decimal.TryParse(PressureReliefOpening, out decimal rv) ? rv.ToString("F1") : string.Empty },
                { "FinalCT1Box", (CheckValve1Leaked ? "Off" : "On") },
                { "FinalCT2Box", (CheckValve2Leaked ? "Off" : "On") },
            };
            SaveFormData(formFields);

            // Load next view model
            var viewModel = new PassFinalViewModel();
            viewModel.LoadPdfData(PdfData ?? throw new InvalidOperationException(),
                FormData ?? throw new InvalidOperationException());
            await Shell.Current.GoToAsync("PassFinal", new Dictionary<string, object>
            {
                { "ViewModel", viewModel }
            });
        }
        else
        {
            // send to repair screen
            await Application.Current.MainPage.DisplayAlert(
                "Missing implementation",
                $"The backflow failed, the next view model hasn't been implemented.",
                "OK"
            );
            return;
        }
    }

    #endregion

    #region Private methods

    private bool IsBackflowPassing()
    {
        // Return false if any component has leaked or failed to open
        if (CheckValve1Leaked || CheckValve2Leaked || ReliefValveDidNotOpen)
        {
            return false;
        }

        // Parse input values to decimal for numerical comparison
        if (!decimal.TryParse(_checkValve1, out decimal checkValve1Value) ||
            !decimal.TryParse(_pressureReliefOpening, out decimal reliefValveValue))
        {
            return false; // Invalid input values
        }

        // Check if Check Valve 1 is <= 5 PSID
        if (checkValve1Value < 5.0m)
        {
            return false;
        }

        // Check if Relief Valve is <= 2 PSID
        if (reliefValveValue < 2.0m)
        {
            return false;
        }

        if (checkValve1Value -3.0m < reliefValveValue)
        {
            return false;
        }

        // TODO: Add shut off valve #2 checkstate

        return true;
    }

    #endregion
}