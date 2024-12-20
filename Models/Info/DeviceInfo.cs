namespace ReportFlow.Models.Info;

public class LocationDetails
{
    public string? WaterPurveyor { get; set; }
    public string? WaterMeterNo { get; set; }
    public string? AssemblyAddress { get; set; }
    public string? OnSiteLocation { get; set; }
    public string? PrimaryService { get; set; }
}

public class InstallationDetails
{
    public string? InstallationStatus { get; set; }
    public string? ProtectionType { get; set; }
    public string? ServiceType { get; set; }
}

public class DeviceDetails
{
    public string? Type { get; set; }
    public string? Manufacturer { get; set; }
    public string? Size { get; set; }
    public string? ModelNo { get; set; }
    public string? SerialNo { get; set; }
}

public class DeviceInfo
{
    public LocationDetails Location { get; set; } = new();
    public InstallationDetails Installation { get; set; } = new();
    public DeviceDetails Device { get; set; } = new();

    public Dictionary<string, string> ToFormFields()
    {
        return new Dictionary<string, string>
        {
            { "WaterPurveyor", Location.WaterPurveyor ?? string.Empty },
            { "AssemblyAddress", Location.AssemblyAddress ?? string.Empty },
            { "On Site Location of Assembly", Location.OnSiteLocation ?? string.Empty },
            { "PrimaryBusinessService", Location.PrimaryService ?? string.Empty },
            { "WaterMeterNo", Location.WaterMeterNo ?? string.Empty },

            { "InstallationIs", Installation.InstallationStatus ?? string.Empty },
            { "ProtectionType", Installation.ProtectionType ?? string.Empty },
            { "ServiceType", Installation.ServiceType ?? string.Empty },

            { "SerialNo", Device.SerialNo ?? string.Empty },
            { "ModelNo", Device.ModelNo ?? string.Empty },
            { "Size", Device.Size ?? string.Empty },
            { "Manufacturer", Device.Manufacturer ?? string.Empty },
            { "BFType", Device.Type ?? string.Empty }
        };
    }

    public static DeviceInfo FromFormFields(Dictionary<string, string> formData)
    {
        return new DeviceInfo
        {
            Location = new LocationDetails
            {
                WaterPurveyor = formData.GetValueOrDefault("WaterPurveyor"),
                AssemblyAddress = formData.GetValueOrDefault("AssemblyAddress"),
                OnSiteLocation = formData.GetValueOrDefault("On Site Location of Assembly"),
                PrimaryService = formData.GetValueOrDefault("PrimaryBusinessService"),
                WaterMeterNo = formData.GetValueOrDefault("WaterMeterNo")
            },
            Installation = new InstallationDetails
            {
                InstallationStatus = formData.GetValueOrDefault("InstallationIs"),
                ProtectionType = formData.GetValueOrDefault("ProtectionType"),
                ServiceType = formData.GetValueOrDefault("ServiceType")
            },
            Device = new DeviceDetails
            {
                SerialNo = formData.GetValueOrDefault("SerialNo"),
                ModelNo = formData.GetValueOrDefault("ModelNo"),
                Size = formData.GetValueOrDefault("Size"),
                Manufacturer = formData.GetValueOrDefault("Manufacturer"),
                Type = formData.GetValueOrDefault("BFType")
            }
        };
    }
}