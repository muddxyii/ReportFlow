namespace ReportFlow.Models.Repair;

public class CheckValveDetails
{
    public bool Cleaned { get; set; }
    public bool CheckDisc { get; set; }
    public bool DiscHolder { get; set; }
    public bool Spring { get; set; }
    public bool Guide { get; set; }
    public bool Seat { get; set; }
    public bool Other { get; set; }
}

public class ValveDetails
{
    public bool Cleaned { get; set; }
    public bool RubberKit { get; set; }
    public bool DiscHolder { get; set; }
    public bool Spring { get; set; }
    public bool Guide { get; set; }
    public bool Seat { get; set; }
    public bool Other { get; set; }
}

public class RepairInfo
{
    public CheckValveDetails Check1 { get; set; } = new();
    public CheckValveDetails Check2 { get; set; } = new();
    public ValveDetails RV { get; set; } = new();
    public ValveDetails PVB { get; set; } = new();
    public bool WasRepaired { get; set; }
    public bool SkippedRepair { get; set; }

    public Dictionary<string, string> ToFormFields()
    {
        return new Dictionary<string, string>
        {
            { "Ck1Cleaned", Check1.Cleaned ? "On" : "Off" },
            { "Ck1CheckDisc", Check1.CheckDisc ? "On" : "Off" },
            { "Ck1DiscHolder", Check1.DiscHolder ? "On" : "Off" },
            { "Ck1Spring", Check1.Spring ? "On" : "Off" },
            { "Ck1Guide", Check1.Guide ? "On" : "Off" },
            { "Ck1Seat", Check1.Seat ? "On" : "Off" },
            { "Ck1Other", Check1.Other ? "On" : "Off" },

            { "Ck2Cleaned", Check2.Cleaned ? "On" : "Off" },
            { "Ck2CheckDisc", Check2.CheckDisc ? "On" : "Off" },
            { "Ck2DiscHolder", Check2.DiscHolder ? "On" : "Off" },
            { "Ck2Spring", Check2.Spring ? "On" : "Off" },
            { "Ck2Guide", Check2.Guide ? "On" : "Off" },
            { "Ck2Seat", Check2.Seat ? "On" : "Off" },
            { "Ck2Other", Check2.Other ? "On" : "Off" },

            { "RVCleaned", RV.Cleaned ? "On" : "Off" },
            { "RVRubberKit", RV.RubberKit ? "On" : "Off" },
            { "RVDiscHolder", RV.DiscHolder ? "On" : "Off" },
            { "RVSpring", RV.Spring ? "On" : "Off" },
            { "RVGuide", RV.Guide ? "On" : "Off" },
            { "RVSeat", RV.Seat ? "On" : "Off" },
            { "RVOther", RV.Other ? "On" : "Off" },

            { "PVBCleaned", PVB.Cleaned ? "On" : "Off" },
            { "PVBRubberKit", PVB.RubberKit ? "On" : "Off" },
            { "PVBDiscHolder", PVB.DiscHolder ? "On" : "Off" },
            { "PVBSpring", PVB.Spring ? "On" : "Off" },
            { "PVBGuide", PVB.Guide ? "On" : "Off" },
            { "PVBSeat", PVB.Seat ? "On" : "Off" },
            { "PVBOther", PVB.Other ? "On" : "Off" }
        };
    }

    public static RepairInfo FromFormFields(Dictionary<string, string> formData)
    {
        return new RepairInfo
        {
            Check1 = new CheckValveDetails
            {
                Cleaned = formData.GetValueOrDefault("Ck1Cleaned") == "On",
                CheckDisc = formData.GetValueOrDefault("Ck1CheckDisc") == "On",
                DiscHolder = formData.GetValueOrDefault("Ck1DiscHolder") == "On",
                Spring = formData.GetValueOrDefault("Ck1Spring") == "On",
                Guide = formData.GetValueOrDefault("Ck1Guide") == "On",
                Seat = formData.GetValueOrDefault("Ck1Seat") == "On",
                Other = formData.GetValueOrDefault("Ck1Other") == "On"
            },
            Check2 = new CheckValveDetails
            {
                Cleaned = formData.GetValueOrDefault("Ck2Cleaned") == "On",
                CheckDisc = formData.GetValueOrDefault("Ck2CheckDisc") == "On",
                DiscHolder = formData.GetValueOrDefault("Ck2DiscHolder") == "On",
                Spring = formData.GetValueOrDefault("Ck2Spring") == "On",
                Guide = formData.GetValueOrDefault("Ck2Guide") == "On",
                Seat = formData.GetValueOrDefault("Ck2Seat") == "On",
                Other = formData.GetValueOrDefault("Ck2Other") == "On"
            },
            RV = new ValveDetails
            {
                Cleaned = formData.GetValueOrDefault("RVCleaned") == "On",
                RubberKit = formData.GetValueOrDefault("RVRubberKit") == "On",
                DiscHolder = formData.GetValueOrDefault("RVDiscHolder") == "On",
                Spring = formData.GetValueOrDefault("RVSpring") == "On",
                Guide = formData.GetValueOrDefault("RVGuide") == "On",
                Seat = formData.GetValueOrDefault("RVSeat") == "On",
                Other = formData.GetValueOrDefault("RVOther") == "On"
            },
            PVB = new ValveDetails
            {
                Cleaned = formData.GetValueOrDefault("PVBCleaned") == "On",
                RubberKit = formData.GetValueOrDefault("PVBRubberKit") == "On",
                DiscHolder = formData.GetValueOrDefault("PVBDiscHolder") == "On",
                Spring = formData.GetValueOrDefault("PVBSpring") == "On",
                Guide = formData.GetValueOrDefault("PVBGuide") == "On",
                Seat = formData.GetValueOrDefault("PVBSeat") == "On",
                Other = formData.GetValueOrDefault("PVBOther") == "On"
            }
        };
    }
}