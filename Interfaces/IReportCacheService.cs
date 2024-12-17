using System.Text.Json;

namespace ReportFlow.Interfaces;

public interface IReportCacheService
{
    Task SaveReportDataAsync(string reportId, Dictionary<string, string> formData);
    Task<Dictionary<string, string>?> LoadReportDataAsync(string reportId);
    Task<IEnumerable<string?>> GetSavedReportIdsAsync();
    Task DeleteReportDataAsync(string reportId);
}