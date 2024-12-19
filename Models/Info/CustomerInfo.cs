namespace ReportFlow.Models.Info;

public class FacilityOwnerDetails
{
    public string? Name { get; set; } = string.Empty;
    public string? Address { get; set; } = string.Empty;
    public string? Email { get; set; } = string.Empty;
    public string? Contact { get; set; } = string.Empty;
    public string? Phone { get; set; } = string.Empty;
}

public class RepresentativeDetails
{
    public string? Name { get; set; } = string.Empty;
    public string? Address { get; set; } = string.Empty;
    public string? Contact { get; set; } = string.Empty;
    public string? Phone { get; set; } = string.Empty;
}

public class CustomerInfo
{
    public string? PermitNumber { get; set; } = string.Empty;
    public FacilityOwnerDetails? OwnerDetails { get; set; }
    public RepresentativeDetails? RepDetails { get; set; }

    public Dictionary<string, string> ToFormFields()
    {
        return new Dictionary<string, string>
        {
            // Permit Account No.
            { "PermitAccountNo", PermitNumber ?? string.Empty },

            // Facility Owner Details
            { "FacilityOwner", OwnerDetails?.Name ?? string.Empty },
            { "Address", OwnerDetails?.Address ?? string.Empty },
            { "Contact", OwnerDetails?.Contact ?? string.Empty },
            { "Phone", OwnerDetails?.Phone ?? string.Empty },
            { "Email", OwnerDetails?.Email ?? string.Empty },

            // Rep Details
            { "OwnerRep", RepDetails?.Name ?? string.Empty },
            { "RepAddress", RepDetails?.Address ?? string.Empty },
            { "PersontoContact", RepDetails?.Contact ?? string.Empty },
            { "Phone-0", RepDetails?.Phone ?? string.Empty }
        };
    }

    public static CustomerInfo FromFormFields(Dictionary<string, string> formData)
    {
        return new CustomerInfo
        {
            PermitNumber = formData.GetValueOrDefault("PermitAccountNo"),
            OwnerDetails = new FacilityOwnerDetails
            {
                Name = formData.GetValueOrDefault("FacilityOwner"),
                Address = formData.GetValueOrDefault("Address"),
                Contact = formData.GetValueOrDefault("Contact"),
                Phone = formData.GetValueOrDefault("Phone"),
                Email = formData.GetValueOrDefault("Email")
            },
            RepDetails = new RepresentativeDetails
            {
                Name = formData.GetValueOrDefault("OwnerRep"),
                Address = formData.GetValueOrDefault("RepAddress"),
                Contact = formData.GetValueOrDefault("PersontoContact"),
                Phone = formData.GetValueOrDefault("Phone-0")
            }
        };
    }
}