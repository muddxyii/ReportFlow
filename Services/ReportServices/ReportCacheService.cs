using System.Text.Json;
using ReportFlow.Interfaces;

namespace ReportFlow.Services.ReportServices;


public class ReportCacheService : IReportCacheService
{
    private readonly string _cachePath;

    /// <summary>
    /// Initializes a new instance of the <see cref="ReportCacheService"/> class.
    /// Determines the cache storage path based on the platform (Android or other OS).
    /// The cache directory is created if it does not already exist.
    /// </summary>
    public ReportCacheService()
    {
        if (DeviceInfo.Platform == DevicePlatform.Android)
        {
            // Use app-specific external storage on Android
            var fileHelper = IPlatformApplication.Current?.Services.GetService<IFileHelper>();
            _cachePath = fileHelper?.GetPublicStoragePath(Path.Combine("ReportFlow", "Caches"));
        }
        else
        {
            // Use the Documents folder for other platforms
            _cachePath = Path.Combine(
                Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments),
                "ReportFlow",
                "Caches");
        }

        Directory.CreateDirectory(_cachePath); // Ensure the directory exists
    }

    /// <summary>
    /// Constructs the path for a specific report based on its unique identifier.
    /// Ensures the directory for the report exists.
    /// </summary>
    /// <param name="reportId">The unique identifier for the report.</param>
    /// <returns>The file path for the report.</returns>
    private string GetReportPath(string reportId)
    {
        var path = Path.Combine(_cachePath, reportId);
        Directory.CreateDirectory(path); // Ensure the directory for the report exists
        return path;
    }

    /// <summary>
    /// Constructs the file path for the report's data file.
    /// </summary>
    /// <param name="reportId">The unique identifier for the report.</param>
    /// <returns>The file path for the data file.</returns>
    private string GetDataFilePath(string reportId) =>
        Path.Combine(GetReportPath(reportId), "ReportData.json");

    /// <summary>
    /// Constructs the file path for the report's metadata file.
    /// </summary>
    /// <param name="reportId">The unique identifier for the report.</param>
    /// <returns>The file path for the metadata file.</returns>
    private string GetMetadataFilePath(string reportId) =>
        Path.Combine(GetReportPath(reportId), "Metadata.json");

    /// <inheritdoc />
    /// <summary>
    /// Saves the report form data to a file and updates the corresponding metadata file.
    /// Creates new metadata or updates the existing one for the specified report.
    /// </summary>
    /// <param name="reportId">The unique identifier for the report.</param>
    /// <param name="formData">A dictionary containing the form data to be saved.</param>
    /// <returns>A task representing the asynchronous save operation.</returns>
    public async Task SaveReportDataAsync(string reportId, Dictionary<string, string> formData)
    {
        var dataFilePath = GetDataFilePath(reportId);
        var metadataFilePath = GetMetadataFilePath(reportId);

        // Save form data as JSON
        var json = JsonSerializer.Serialize(formData);
        await File.WriteAllTextAsync(dataFilePath, json);

        // Update or create metadata
        ReportMetadata metadata;
        if (File.Exists(metadataFilePath))
        {
            // Metadata already exists; update last modification date
            var existingJson = await File.ReadAllTextAsync(metadataFilePath);
            metadata = JsonSerializer.Deserialize<ReportMetadata>(existingJson) ??
                       new ReportMetadata(reportId);
            metadata.LastModifiedDate = DateTime.Now;
        }
        else
        {
            // Metadata does not exist; create a new metadata object
            metadata = new ReportMetadata(reportId);
        }

        // Save the updated metadata file
        await File.WriteAllTextAsync(
            metadataFilePath,
            JsonSerializer.Serialize(metadata)
        );
    }

    /// <inheritdoc />
    /// <summary>
    /// Loads the report form data from a file corresponding to the given report ID.
    /// If the report file does not exist, returns null.
    /// </summary>
    /// <param name="reportId">The unique identifier for the report.</param>
    /// <returns>
    /// A dictionary of the report data if the file exists, or null if it does not.
    /// </returns>
    public async Task<Dictionary<string, string>?> LoadReportDataAsync(string reportId)
    {
        var filePath = GetDataFilePath(reportId);
        if (!File.Exists(filePath))
            return null; // Report file does not exist

        var json = await File.ReadAllTextAsync(filePath); // Read JSON content
        return JsonSerializer.Deserialize<Dictionary<string, string>>(json);
    }

    /// <inheritdoc />
    /// <summary>
    /// Retrieves the metadata associated with a specific report based on its unique identifier.
    /// Returns null if the metadata file does not exist.
    /// </summary>
    /// <param name="reportId">The unique identifier for the report.</param>
    /// <returns>The report metadata, or null if it does not exist.</returns>
    public async Task<ReportMetadata?> GetReportMetadataAsync(string reportId)
    {
        var filePath = GetMetadataFilePath(reportId);
        if (!File.Exists(filePath))
            return null; // Metadata file does not exist

        var json = await File.ReadAllTextAsync(filePath); // Read JSON content
        return JsonSerializer.Deserialize<ReportMetadata>(json);
    }

    /// <inheritdoc />
    /// <summary>
    /// Retrieves metadata for all saved reports, ordered by the last modified date in descending order.
    /// </summary>
    /// <returns>An enumerable collection of report metadata.</returns>
    public async Task<IEnumerable<ReportMetadata>> GetAllReportMetadataAsync()
    {
        var reports = new List<ReportMetadata>();

        // Iterate through directories corresponding to report IDs
        foreach (var reportDir in Directory.GetDirectories(_cachePath))
        {
            var reportId = Path.GetFileName(reportDir);

            // Retrieve metadata for each report
            var metadata = await GetReportMetadataAsync(reportId);
            if (metadata != null)
            {
                reports.Add(metadata);
            }
        }

        return reports.OrderByDescending(m => m.LastModifiedDate); // Sort in descending order
    }

    /// <inheritdoc />
    /// <summary>
    /// Deletes the report data and associated metadata from the cache.
    /// </summary>
    /// <param name="reportId">The unique identifier for the report to be deleted.</param>
    /// <returns>A task representing the asynchronous delete operation.</returns>
    public Task DeleteReportDataAsync(string reportId)
    {
        var dirPath = GetReportPath(reportId);

        // Remove the directory and its contents if it exists
        if (Directory.Exists(dirPath))
            Directory.Delete(dirPath, true);

        return Task.CompletedTask;
    }

    /// <inheritdoc />
    /// <summary>
    /// Retrieves the list of saved report IDs by scanning the subdirectories of the cache directory.
    /// </summary>
    /// <returns>A collection of saved report IDs as strings.</returns>
    public Task<IEnumerable<string?>> GetSavedReportIdsAsync()
    {
        return Task.FromResult(Directory.GetDirectories(_cachePath)
            .Select(Path.GetFileName) // Extract report IDs (directory names)
            .Where(name => name != null)); // Filter non-null names
    }
}