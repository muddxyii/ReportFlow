using System.Diagnostics;
using System.Text.Json;
using ReportFlow.Interfaces;

namespace ReportFlow.Services.ReportServices;

/// <summary>
///     Provides caching functionality for report data, including saving, loading, and managing report metadata.
///     Implements the <see cref="IReportCacheService" /> interface to support report data operations.
/// </summary>
public class ReportCacheService : IReportCacheService
{
    /// <summary>
    ///     Represents the configuration options for JSON serialization and deserialization within the
    ///     <see cref="ReportCacheService" />.
    ///     This static instance of <see cref="JsonSerializerOptions" /> is used to control the formatting and property naming
    ///     policy
    ///     when handling JSON data, ensuring consistency across all JSON-related operations performed by the service.
    /// </summary>
    private static readonly JsonSerializerOptions _jsonOptions = new()
    {
        WriteIndented = true,
        PropertyNamingPolicy = JsonNamingPolicy.CamelCase
    };

    /// <summary>
    ///     Represents the file system path used to store cached data for reports.
    ///     This path is conditionally assigned based on the platform:
    ///     - On Android, it uses app-specific external storage.
    ///     - On other platforms, it uses a path within the user's Documents folder.
    ///     The directory is ensured to exist upon initialization of the service.
    /// </summary>
    private readonly string _cachePath;

    /// <summary>
    ///     Provides services for managing the caching of report data, including saving, loading,
    ///     updating metadata, and deleting report data files. Implements cross-platform handling
    ///     for cache storage based on the operating system.
    /// </summary>
    public ReportCacheService()
    {
        _cachePath = Path.Combine(
            FileSystem.Current.AppDataDirectory,
            "ReportFlow",
            "Caches");

        Directory.CreateDirectory(_cachePath); // Ensure the directory exists
    }

    /// <summary>
    ///     Saves the report form data to a file and updates metadata associated with the specified report.
    ///     This operation involves creating or updating the metadata file.
    /// </summary>
    /// <param name="reportId">The unique identifier for the report for which data is being saved.</param>
    /// <param name="formData">A dictionary containing the report form data to be serialized and saved.</param>
    /// <returns>A task representing the asynchronous save operation.</returns>
    public async Task SaveReportDataAsync(string reportId, Dictionary<string, string> formData)
    {
        var dataFilePath = GetDataFilePath(reportId);
        var metadataFilePath = GetMetadataFilePath(reportId);

        // Save form data as JSON
        var json = JsonSerializer.Serialize(formData, _jsonOptions);
        await File.WriteAllTextAsync(dataFilePath, json);

        // Update or create metadata
        ReportMetadata metadata;
        if (File.Exists(metadataFilePath))
        {
            // Metadata already exists; update last modification date
            var existingJson = await File.ReadAllTextAsync(metadataFilePath);
            metadata = JsonSerializer.Deserialize<ReportMetadata>(existingJson, _jsonOptions) ??
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
            JsonSerializer.Serialize(metadata, _jsonOptions)
        );
    }

    /// <summary>
    ///     Asynchronously loads the report form data corresponding to the provided report ID from a stored file.
    ///     If the specified report file does not exist, the method returns null.
    /// </summary>
    /// <param name="reportId">The unique identifier of the report.</param>
    /// <returns>
    ///     A task that represents the asynchronous operation. The task's result contains a dictionary of the report data
    ///     if the file exists, or null if the file does not exist.
    /// </returns>
    public async Task<Dictionary<string, string>?> LoadReportDataAsync(string reportId)
    {
        var filePath = GetDataFilePath(reportId);
        if (!File.Exists(filePath))
            return null; // Report file does not exist

        var json = await File.ReadAllTextAsync(filePath); // Read JSON content
        return JsonSerializer.Deserialize<Dictionary<string, string>>(json);
    }

    /// <summary>
    ///     Asynchronously retrieves the metadata associated with a specific report based on its unique identifier.
    ///     Returns null if the metadata file does not exist.
    /// </summary>
    /// <param name="reportId">The unique identifier for the report.</param>
    /// <returns>
    ///     A task that represents the asynchronous operation. The task result contains the report metadata, or null if it
    ///     does not exist.
    /// </returns>
    public async Task<ReportMetadata?> GetReportMetadataAsync(string reportId)
    {
        var filePath = GetMetadataFilePath(reportId);
        if (!File.Exists(filePath))
            return null; // Metadata file does not exist

        var json = await File.ReadAllTextAsync(filePath); // Read JSON content
        return JsonSerializer.Deserialize<ReportMetadata>(json, _jsonOptions);
    }

    /// <summary>
    ///     Retrieves metadata for all saved reports, ordered by the last modified date in descending order.
    /// </summary>
    /// <returns>An enumerable collection of report metadata.</returns>
    public async Task<IEnumerable<ReportMetadata>> GetAllReportMetadataAsync()
    {
        var reports = new List<ReportMetadata>();

        try
        {
            // Only process directories that exist and have valid report IDs
            var reportDirs = Directory.GetDirectories(_cachePath)
                .Select(dir => Path.GetFileName(dir))
                .Where(reportId => !string.IsNullOrWhiteSpace(reportId));

            foreach (var reportId in reportDirs)
                try
                {
                    var metadata = await GetReportMetadataAsync(reportId!);
                    if (metadata != null && !string.IsNullOrWhiteSpace(metadata.ReportId)) reports.Add(metadata);
                }
                catch (Exception ex)
                {
                    Debug.WriteLine($"Error loading metadata for report {reportId}: {ex.Message}");
                    // Continue to next report instead of breaking the entire loop
                }

            return reports.OrderByDescending(m => m.LastModifiedDate);
        }
        catch (Exception ex)
        {
            Debug.WriteLine($"Error getting report metadata: {ex.Message}");
            return Enumerable.Empty<ReportMetadata>();
        }
    }

    /// <summary>
    ///     Deletes the report data and associated metadata from the cache.
    /// </summary>
    /// <param name="reportId">The unique identifier for the report to be deleted.</param>
    /// <returns>A task that represents the asynchronous operation, which completes when the report is deleted.</returns>
    public Task DeleteReportDataAsync(string reportId)
    {
        var dirPath = GetReportPath(reportId);

        // Remove the directory and its contents if it exists
        if (Directory.Exists(dirPath))
            Directory.Delete(dirPath, true);

        return Task.CompletedTask;
    }

    /// <summary>
    ///     Retrieves the list of saved report IDs by scanning the subdirectories of the cache directory.
    /// </summary>
    /// <returns>A collection of saved report IDs as strings.</returns>
    public Task<IEnumerable<string?>> GetSavedReportIdsAsync()
    {
        return Task.FromResult(Directory.GetDirectories(_cachePath)
            .Select(Path.GetFileName) // Extract report IDs (directory names)
            .Where(name => name != null)); // Filter non-null names
    }

    /// <summary>
    ///     Constructs the path for a specific report based on its unique identifier.
    ///     Ensures the directory for the report exists.
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
    ///     Constructs the file path for the report's data file.
    /// </summary>
    /// <param name="reportId">The unique identifier for the report.</param>
    /// <returns>The file path for the data file.</returns>
    private string GetDataFilePath(string reportId)
    {
        return Path.Combine(GetReportPath(reportId), "ReportData.json");
    }

    /// <summary>
    ///     Constructs the file path for the report's metadata file.
    /// </summary>
    /// <param name="reportId">The unique identifier for the report.</param>
    /// <returns>The file path for the metadata file.</returns>
    private string GetMetadataFilePath(string reportId)
    {
        return Path.Combine(GetReportPath(reportId), "Metadata.json");
    }
}