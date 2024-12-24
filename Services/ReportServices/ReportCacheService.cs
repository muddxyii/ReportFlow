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

    private static readonly SemaphoreSlim _saveLock = new(1, 1);

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
        await _saveLock.WaitAsync();
        try
        {
            var filePath = GetReportPath(report.Metadata.ReportId);
            var json = JsonSerializer.Serialize(report, JsonOptions);
            await File.WriteAllTextAsync(filePath, json);
        }
        finally
        {
            _saveLock.Release();
        }
    }

    public async Task<ReportData?> LoadReportAsync(string reportId)
    {
        await _saveLock.WaitAsync();
        try
        {
            var filePath = GetReportPath(reportId);
            if (!File.Exists(filePath)) return null;

            var json = await File.ReadAllTextAsync(filePath);
            return JsonSerializer.Deserialize<ReportData>(json, JsonOptions);
        }
        finally
        {
            _saveLock.Release();
        }
    }

    public async Task<IEnumerable<ReportData>> GetAllReportsAsync()
    {
        await _saveLock.WaitAsync();
        try
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
        finally
        {
            _saveLock.Release();
        }
    }

    public async Task DeleteReportAsync(string reportId)
    {
        await _saveLock.WaitAsync();
        try
        {
            var filePath = GetReportPath(reportId);
            if (File.Exists(filePath)) File.Delete(filePath);
        }
        finally
        {
            _saveLock.Release();
        }
    }

    private string GetReportPath(string reportId)
    {
        return Path.Combine(_cachePath, $"{reportId}.json");
    }
}