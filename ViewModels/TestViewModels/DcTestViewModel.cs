namespace ABFReportEditor.ViewModels.TestViewModels;

public class DcTestViewModel : BaseBackflowViewModel
{
    // Private fields
    private string? _linePressure;
    private string? _checkValve1;
    private string? _checkValve2;
    
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