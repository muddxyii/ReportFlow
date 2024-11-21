namespace ABFReportEditor.ViewModels.TestViewModels;

public class DcTestViewModel : BaseBackflowViewModel
{
    // Private fields
    private string? _linePressure;
    private string? _checkValve1;
    private string? _checkValve2;
    private bool _checkValve1Leaked;
    private bool _checkValve2Leaked;
    
    // Properties
    public string? LinePressure
    {
        get => _linePressure;
        set
        {
            _linePressure = value;
            OnPropertyChanged(nameof(LinePressure));
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
    
    // Methods
    protected override void LoadFormFields(Dictionary<string, string> formFields)
    {
        // Don't load previous fields
    }

    protected override async Task OnNext()
    {
        // TODO: Implement pass/fail logic
        await Shell.Current.GoToAsync("PassFinal");
    }
}