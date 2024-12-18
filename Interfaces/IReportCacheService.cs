using System.Text.Json;
using ReportFlow.Services.ReportServices;

namespace ReportFlow.Interfaces;

/// <summary>
/// Provides functionality for managing the caching of report data and associated metadata.
/// This service handles saving, loading, retrieving metadata, and deleting cached reports 
/// in an efficient and structured way, supporting asynchronous operations.
/// </summary>
public interface IReportCacheService
{
    /// <summary>
    /// Saves the form data of a report asynchronously.
    /// This method persists the report data and updates or creates the associated metadata.
    /// </summary>
    /// <param name="reportId">The unique identifier of the report to save.</param>
    /// <param name="formData">A dictionary containing the key-value pairs of form data to be saved.</param>
    /// <returns>An asynchronous task that represents the save operation.</returns>
    Task SaveReportDataAsync(string reportId, Dictionary<string, string> formData);

    /// <summary>
    /// Loads the cached form data of a report asynchronously.
    /// This method retrieves the saved report data if it exists in the cache.
    /// </summary>
    /// <param name="reportId">The unique identifier of the report to load.</param>
    /// <returns>An asynchronous task that returns a dictionary containing the key-value pairs of the report data, or null if no cached data exists.</returns>
    Task<Dictionary<string, string>?> LoadReportDataAsync(string reportId);

    /// <summary>
    /// Retrieves the list of saved report identifiers asynchronously.
    /// This method scans the cache directory and extracts unique directory names representing saved report IDs.
    /// </summary>
    /// <returns>A task that represents the asynchronous operation, containing a collection of saved report identifiers.</returns>
    Task<IEnumerable<string?>> GetSavedReportIdsAsync();

    /// <summary>
    /// Deletes the cached data and metadata of a specific report asynchronously.
    /// </summary>
    /// <param name="reportId">The unique identifier of the report to delete from the cache.</param>
    /// <returns>A task that represents the asynchronous delete operation.</returns>
    Task DeleteReportDataAsync(string reportId);

    /// <summary>
    /// Retrieves the metadata associated with a specified report asynchronously.
    /// This method loads metadata information related to the report's unique identifier,
    /// returning null if no metadata is found.
    /// </summary>
    /// <param name="reportId">The unique identifier of the report whose metadata is being retrieved.</param>
    /// <returns>An asynchronous task that returns the report metadata, or null if the metadata does not exist.</returns>
    Task<ReportMetadata?> GetReportMetadataAsync(string reportId);

    /// <summary>
    /// Retrieves metadata for all saved reports asynchronously.
    /// This method fetches the metadata for all cached reports and returns them
    /// in a collection ordered by the last modified date in descending order.
    /// </summary>
    /// <returns>A task representing the asynchronous operation, containing an enumerable collection of report metadata.</returns>
    Task<IEnumerable<ReportMetadata>> GetAllReportMetadataAsync();
}