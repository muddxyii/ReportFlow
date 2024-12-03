using ABFReportEditor.ViewModels.FinalViewModels;

namespace ABFReportEditor.ViewModels.TestViewModels;

public class PvbTestViewModel : BaseTestViewModel
{
    protected override async Task<bool> ValidateFields()
    {
        // Do base validation
        if (!await base.ValidateFields()) return false;
        
        // Do PVB Specific Checks
        if (!await AreFieldsValid(new (string Value, string Name)[]
            {
                (AirInletOpening ?? "", "Air Inlet Opening"),
                (CkPvb ?? "", "PVB Check"),
            })) return false;
        
        return true;
    }
    
    protected override bool IsBackflowPassing()
    {
        // Return false if any component has leaked or failed to open
        if (AirInletLeaked || AirInletDidNotOpen || CkPvbLeaked) return false;

        // Check for back pressure
        if (BackPressure?.Equals("YES") ?? true) return false;
        
        // Parse input values to decimal for numerical comparison
        if (!decimal.TryParse(AirInletOpening, out decimal airInletValue) ||
            !decimal.TryParse(CkPvb, out decimal ck1Pvb))
        {
            return false; // Invalid input values
        }

        // Check if Air Inlet Open and Check 1 <= 1
        if (airInletValue <= 1 || ck1Pvb <= 1)
        {
            return false;
        }

        return true;
    }
}