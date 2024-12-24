namespace ReportFlow.Services.ReportServices;

/// <summary>
/// Represents metadata associated with a report, including information such as
/// creation date, last modification date, report identifier, report type, and the creator.
/// </summary>
public class ReportMetadata
{
    /// Represents the date and time when the report metadata was created.
    /// This property is initialized to the current UTC time when a new instance
    /// of the ReportMetadata class is constructed. It is immutable and cannot
    /// be modified after initialization.
    public DateTime CreatedDate { get; set; }

    /// Represents the date and time when the report metadata was last modified.
    /// The property is updated whenever changes are made to the report data or metadata.
    /// It is utilized for sorting and organizing reports, as well as tracking modifications.
    public DateTime LastModifiedDate { get; set; }

    /// <summary>
    /// Gets or sets the unique identifier for the report.
    /// </summary>
    /// <remarks>
    /// This property is used as a primary identifier for reports across various
    /// services and components. It must be a non-null, unique string that enables
    /// retrieving, caching, and displaying report data.
    /// </remarks>
    public string ReportId { get; set; }

    /// <summary>
    /// Gets or sets the type of the report.
    /// </summary>
    /// <remarks>
    /// This property specifies the classification or category of the report and is
    /// intended to provide contextual information about the nature of the report.
    /// The value of this property can be null to represent an unspecified type.
    /// </remarks>
    public string? ReportType { get; set; }

    /// Gets or sets the identifier of the user who created the report.
    /// This property represents the creator of the report and is used to
    /// track ownership or authorship of the report within the system.
    public string? CreatedBy { get; set; }

    /// Represents metadata associated with a report.
    /// Provides information such as the creation date, last modification date,
    /// report type, and the creator of the report.
    public ReportMetadata(string reportId)
    {
        ReportId = reportId;
        ReportType = "ReportFlow";
        LastModifiedDate = DateTime.UtcNow;
    }

    /// <summary>
    /// Represents metadata associated with a report.
    /// </summary>
    private ReportMetadata()
    {
    }
}