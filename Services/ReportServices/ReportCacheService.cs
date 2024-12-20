using System.Diagnostics;
using System.Text.Json;
using ReportFlow.Interfaces;
using ReportFlow.Models;

namespace ReportFlow.Services.ReportServices;

/// <summary>
///     Provides caching functionality for report data, including saving, loading, and managing report metadata.
///     Implements the <see cref="IReportCacheService" /> interface to support report data operations.
/// </summary>
public class ReportCacheService : IReportCacheService
{
    private static readonly JsonSerializerOptions JsonOptions = new()
    {
        WriteIndented = true,
        PropertyNamingPolicy = JsonNamingPolicy.CamelCase
    };

    private readonly string _cachePath;

    public ReportCacheService()
    {
        _cachePath = Path.Combine(
            FileSystem.Current.AppDataDirectory,
            "ReportFlow",
            "Reports");

        Directory.CreateDirectory(_cachePath);
    }


    public async Task SaveReportAsync(ReportData report)
    {
        var filePath = GetReportPath(report.Metadata.ReportId);
        var json = JsonSerializer.Serialize(report, JsonOptions);
        await File.WriteAllTextAsync(filePath, json);
    }

    public async Task<ReportData?> LoadReportAsync(string reportId)
    {
        var filePath = GetReportPath(reportId);
        if (!File.Exists(filePath)) return null;

        var json = await File.ReadAllTextAsync(filePath);
        return JsonSerializer.Deserialize<ReportData>(json, JsonOptions);
    }

    public async Task<IEnumerable<ReportData>> GetAllReportsAsync()
    {
        var reports = new List<ReportData>();
        var files = Directory.GetFiles(_cachePath, "*.json");

        foreach (var file in files)
            try
            {
                var json = await File.ReadAllTextAsync(file);
                var report = JsonSerializer.Deserialize<ReportData>(json, JsonOptions);
                if (report != null) reports.Add(report);
            }
            catch (Exception ex)
            {
                Debug.WriteLine($"Error loading report: {ex.Message}");
            }

        return reports.OrderByDescending(r => r.Metadata.LastModifiedDate);
    }

    public Task DeleteReportAsync(string reportId)
    {
        var filePath = GetReportPath(reportId);
        if (File.Exists(filePath)) File.Delete(filePath);
        return Task.CompletedTask;
    }

    private string GetReportPath(string reportId)
    {
        return Path.Combine(_cachePath, $"{reportId}.json");
    }
}