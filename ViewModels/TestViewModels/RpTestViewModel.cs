namespace ReportFlow.ViewModels.TestViewModels;

public class RpTestViewModel(Dictionary<string, string>? formData) : BaseTestViewModel(formData)
{
    protected override async Task<bool> ValidateFields()
    {
        // Do base validation
        if (!await base.ValidateFields()) return false;
        
        // Do RP Specific Checks
        if (!await AreFieldsValid(new (string Value, string Name)[]
            {
                (CheckValve1 ?? "", "Check Valve 1"),
                (PressureReliefOpening ?? "", "Pressure Relief Opening"),
            })) return false;
        
        return true;
    }
    
    protected override bool IsBackflowPassing()
    {
        // Return false if any component has leaked or failed to open
        if (CheckValve1Leaked || CheckValve2Leaked || ReliefValveDidNotOpen || ReliefValveLeaking) return false;
        
        // Parse input values to decimal for numerical comparison
        if (!decimal.TryParse(CheckValve1, out decimal checkValve1Value) ||
            !decimal.TryParse(PressureReliefOpening, out decimal reliefValveValue))
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

        return true;
    }
    
    public RpTestViewModel() : this(new Dictionary<string, string>()) {}
}