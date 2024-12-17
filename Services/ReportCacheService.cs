using ReportFlow.Interfaces;
using System.Text.Json;

namespace ReportFlow.Services;

public class ReportCacheService : IReportCacheService
{
    private readonly string _cachePath;

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
            _cachePath = Path.Combine(
                Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments),
                "ReportFlow",
                "Caches");
        }
        
        Directory.CreateDirectory(_cachePath);
    }

    private string GetReportPath(string reportId)
    {
        var path = Path.Combine(_cachePath, reportId);
        Directory.CreateDirectory(path);
        return Path.Combine(path, "ReportData.json");
    }
    
    public async Task SaveReportDataAsync(string reportId, Dictionary<string, string> formData)
    {
        var filePath = GetReportPath(reportId);
        var json = JsonSerializer.Serialize(formData);
        await File.WriteAllTextAsync(filePath, json);
    }

    public async Task<Dictionary<string, string>?> LoadReportDataAsync(string reportId)
    {
        var filePath = GetReportPath(reportId);
        if (!File.Exists(filePath)) return null;
        
        var json = await File.ReadAllTextAsync(filePath);
        return JsonSerializer.Deserialize<Dictionary<string, string>>(json);
    }

    public Task<IEnumerable<string?>> GetSavedReportIdsAsync()
    {
        return Task.FromResult(Directory.GetDirectories(_cachePath)
            .Select(Path.GetFileName)
            .Where(name => name != null));
    }

    public Task DeleteReportDataAsync(string reportId)
    {
        var dirPath = Path.Combine(_cachePath, reportId);
        if (Directory.Exists(dirPath))
            Directory.Delete(dirPath, true);
        return Task.CompletedTask;
    }
}
