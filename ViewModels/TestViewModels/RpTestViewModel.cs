using ABFReportEditor.ViewModels.FinalViewModels;

namespace ABFReportEditor.ViewModels.TestViewModels;

public class RpTestViewModel : BaseTestViewModel
{
    protected override bool ValidateFields()
    {
        // Do base validation
        if (!base.ValidateFields()) return false;
        
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
                return false;
            }
        }
        
        return true;
    }
    
    protected override bool IsBackflowPassing()
    {
        // Return false if any component has leaked or failed to open
        if (CheckValve1Leaked || CheckValve2Leaked || ReliefValveDidNotOpen)
        {
            return false;
        }

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

        // TODO: Add shut off valve #2 checkstate

        return true;
    }
}