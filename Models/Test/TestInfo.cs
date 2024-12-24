namespace ReportFlow.Models.Test;

public class BackflowTestDetails
{
    public string? LinePressure { get; set; }
    public string? ShutoffValve { get; set; }
    public string? SovComment { get; set; }
}

public class CheckValveDetails
{
    public string? Valve1 { get; set; }
    public string? Valve2 { get; set; }
    public bool Valve1Ct { get; set; }
    public bool Valve2Ct { get; set; }
}

public class ReliefValveDetails
{
    public string? PressureReliefOpening { get; set; }
    public bool ReliefValveDidNotOpen { get; set; }
    public bool ReliefValveLeaking { get; set; }
}

public class PvbDetails
{
    public string? BackPressure { get; set; }
    public string? AirInletOpening { get; set; }
    public bool AirInletLeaked { get; set; }
    public bool AirInletDidNotOpen { get; set; }
    public string? CkPvb { get; set; }
    public bool CkPvbLeaked { get; set; }
}

public class TestInfo
{
    public string BackflowType { get; set; }
    public BackflowTestDetails BackflowTest { get; set; }
    public CheckValveDetails CheckValves { get; set; }
    public ReliefValveDetails ReliefValve { get; set; }
    public PvbDetails Pvb { get; set; }

    public TestInfo(string deviceType)
    {
        BackflowType = deviceType;
        BackflowTest = new BackflowTestDetails();
        CheckValves = new CheckValveDetails();
        ReliefValve = new ReliefValveDetails();
        Pvb = new PvbDetails();
    }

    public TestInfo()
    {
        BackflowType = string.Empty;
        BackflowTest = new BackflowTestDetails();
        CheckValves = new CheckValveDetails();
        ReliefValve = new ReliefValveDetails();
        Pvb = new PvbDetails();
    }

    public Dictionary<string, string> ToFailedFormFields()
    {
        var fields = new Dictionary<string, string>
        {
            { "LinePressure", BackflowTest.LinePressure ?? string.Empty },
            { "SOVList", BackflowTest.ShutoffValve ?? string.Empty },
            { "SOVComment", BackflowTest.SovComment?.ToUpper() ?? string.Empty },

            { "InitialCT1", TryParseDecimal(CheckValves.Valve1) },
            { "InitialCT2", TryParseDecimal(CheckValves.Valve2) },
            { "InitialCTBox", CheckValves.Valve1Ct ? "On" : "Off" },
            { "InitialCT1Leaked", BackflowType is "RP" or "DC" or "SC" && !CheckValves.Valve1Ct ? "On" : "Off" },
            { "InitialCT2Box", CheckValves.Valve2Ct ? "On" : "Off" },
            { "InitialCT2Leaked", BackflowType is "RP" or "DC" && !CheckValves.Valve2Ct ? "On" : "Off" },

            { "InitialPSIRV", FormatReliefValveReading() },
            { "InitialRVDidNotOpen", ReliefValve.ReliefValveDidNotOpen ? "On" : "Off" },

            { "BackPressure", Pvb.BackPressure ?? string.Empty },
            { "InitialAirInlet", TryParseDecimal(Pvb.AirInletOpening) },
            { "InitialAirInletLeaked", Pvb.AirInletLeaked ? "On" : "Off" },
            { "InitialCkPVBLDidNotOpen", Pvb.AirInletDidNotOpen ? "On" : "Off" },
            { "InitialCk1PVB", TryParseDecimal(Pvb.CkPvb) },
            { "InitialCkPVBLeaked", Pvb.CkPvbLeaked ? "On" : "Off" }
        };

        return fields;
    }

    public Dictionary<string, string> ToPassedFormFields()
    {
        var fields = new Dictionary<string, string>
        {
            { "LinePressure", BackflowTest.LinePressure ?? string.Empty },
            { "SOVList", BackflowTest.ShutoffValve ?? string.Empty },
            { "SOVComment", BackflowTest.SovComment?.ToUpper() ?? string.Empty },

            { "FinalCT1", TryParseDecimal(CheckValves.Valve1) },
            { "FinalCT2", TryParseDecimal(CheckValves.Valve2) },
            { "FinalCT1Box", CheckValves.Valve1Ct ? "On" : "Off" },
            { "FinalCT2Box", CheckValves.Valve2Ct ? "On" : "Off" },

            { "FinalRV", TryParseDecimal(ReliefValve.PressureReliefOpening) },

            { "BackPressure", Pvb.BackPressure ?? string.Empty },
            { "FinalAirInlet", TryParseDecimal(Pvb.AirInletOpening) },
            { "Check Valve", TryParseDecimal(Pvb.CkPvb) }
        };

        return fields;
    }

    private string FormatReliefValveReading()
    {
        var reading = TryParseDecimal(ReliefValve.PressureReliefOpening);
        if (ReliefValve.ReliefValveLeaking) return string.IsNullOrEmpty(reading) ? "LEAKING" : $"LEAKING/{reading}";
        return reading;
    }

    private static string TryParseDecimal(string? value)
    {
        return decimal.TryParse(value, out var result) ? result.ToString("F1") : string.Empty;
    }

    public static TestInfo FromFormFields(Dictionary<string, string> formData)
    {
        return new TestInfo(formData.GetValueOrDefault("BFType", string.Empty))
        {
            BackflowTest = new BackflowTestDetails
            {
                LinePressure = formData.GetValueOrDefault("LinePressure"),
                ShutoffValve = formData.GetValueOrDefault("SOVList"),
                SovComment = formData.GetValueOrDefault("SOVComment")
            },
            CheckValves = new CheckValveDetails
            {
                Valve1 = formData.GetValueOrDefault("InitialCT1") ?? formData.GetValueOrDefault("FinalCT1"),
                Valve2 = formData.GetValueOrDefault("InitialCT2") ?? formData.GetValueOrDefault("FinalCT2"),
                Valve1Ct = formData.GetValueOrDefault("InitialCTBox") == "On",
                Valve2Ct = formData.GetValueOrDefault("InitialCT2Box") == "On"
            },
            ReliefValve = new ReliefValveDetails
            {
                PressureReliefOpening = ParseReliefValveReading(formData.GetValueOrDefault("InitialPSIRV") ??
                                                                formData.GetValueOrDefault("FinalRV")),
                ReliefValveDidNotOpen = formData.GetValueOrDefault("InitialRVDidNotOpen") == "On",
                ReliefValveLeaking = formData.GetValueOrDefault("InitialPSIRV")?.StartsWith("LEAKING") ?? false
            },
            Pvb = new PvbDetails
            {
                BackPressure = formData.GetValueOrDefault("BackPressure"),
                AirInletOpening = formData.GetValueOrDefault("InitialAirInlet") ??
                                  formData.GetValueOrDefault("FinalAirInlet"),
                AirInletLeaked = formData.GetValueOrDefault("InitialAirInletLeaked") == "On",
                AirInletDidNotOpen = formData.GetValueOrDefault("InitialCkPVBLDidNotOpen") == "On",
                CkPvb = formData.GetValueOrDefault("InitialCk1PVB") ??
                        formData.GetValueOrDefault("Check Valve"),
                CkPvbLeaked = formData.GetValueOrDefault("InitialCkPVBLeaked") == "On"
            }
        };
    }

    private static string? ParseReliefValveReading(string? value)
    {
        if (string.IsNullOrEmpty(value)) return null;
        return value.StartsWith("LEAKING/") ? value[8..] : value;
    }
}