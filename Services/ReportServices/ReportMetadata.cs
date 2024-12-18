namespace ReportFlow.Services.ReportServices;

public class ReportMetadata
{
    public DateTime CreatedDate { get; }
    public DateTime LastModifiedDate { get; set; }
    public string ReportId { get; set; }
    public string? ReportType { get; set; }
    public string? CreatedBy { get; set; }
    
    public ReportMetadata(string reportId)
    {
        ReportId = reportId;
        CreatedDate = DateTime.Now;
        LastModifiedDate = CreatedDate;
    }
}