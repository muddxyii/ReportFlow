namespace ReportFlow.Models.Info;

public class LocationDetails
{
    public string? CustomWaterPurveyor { get; set; }
    public string? WaterPurveyor { get; set; }
    public string? WaterMeterNo { get; set; }
    public string? AssemblyAddress { get; set; }
    public string? OnSiteLocation { get; set; }
    public string? PrimaryService { get; set; }

    public static List<string> WaterPurveyorList { get; } =
    [
        "CITY OF PHOENIX", "CITY OF GLENDALE", "CITY OF PEORIA",
        "CITY OF BUCKEYE", "CITY OF SCOTTSDALE", "EPCOR WATER",
        "TOWN OF GILBERT", "CITY OF MESA", "CITY OF CHANDLER",
        "CITY OF TEMPE", "APACHE JUNCTION WATER DISTRICT", "CITY OF APACHE JUNCTION",
        "SALT RIVER PIMA MARICOPA INDIAN COMMUNITY", "LIBERTY UTILITIES", "GLOBAL WATER COMPANY",
        "VALLEY UTILITIES WATER CO. INC.", "JOHNSON UTILITIES", "QUEEN CREEK WATER COMPANY",
        "TOWN OF WICKENBURG", "TOWN OF CAVE CREEK", "CARE FREE WATER COMPANY",
        "CITY OF TOLLESON", "CITY OF SURPRISE", "CITY OF EL MIRAGE",
        "ARIZONA WATER COMPANY", "SUNRISE WATER", "GILA RIVER INDIAN COMMUNITY",
        "LUKE AIR FORCE BASE", "PIMA UTILITY COMPANY", "GRAHAM COUNTY UTILITIES",
        "ORO VALLEY", "ARIZONA STATE UNIVERSITY", "NORTHERN ARIZONA UNIVERSITY",
        "CITY OF PRESCOTT", "CITY OF ELOY", "CITY OF GLOBE",
        "CITY OF FLAGSTAFF", "TOWN OF SAFFORD",
        "Custom..."
    ];
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
        var waterPurveyor = Location.WaterPurveyor == "Custom..."
            ? Location.CustomWaterPurveyor
            : Location.WaterPurveyor;

        return new Dictionary<string, string>
        {
            { "WaterPurveyor", waterPurveyor ?? string.Empty },
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
        var customWaterPurveyor = "";
        var waterPurveyor = formData.GetValueOrDefault("WaterPurveyor") ?? string.Empty;
        if (!LocationDetails.WaterPurveyorList.Contains(waterPurveyor))
        {
            customWaterPurveyor = waterPurveyor;
            waterPurveyor = "Custom...";
        }

        return new DeviceInfo
        {
            Location = new LocationDetails
            {
                CustomWaterPurveyor = customWaterPurveyor,
                WaterPurveyor = waterPurveyor,
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
                Manufacturer = formData.GetValueOrDefault("Manufacturer")?.Trim(),
                Type = formData.GetValueOrDefault("BFType")?.Trim()
            }
        };
    }
}