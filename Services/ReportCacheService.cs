using ReportFlow.Interfaces;
using System.Text.Json;

namespace ReportFlow.Services;

public class ReportCacheService : IReportCacheService
{
    private readonly string _cachePath;
    private readonly IFileHelper _fileHelper;

    public ReportCacheService(IFileHelper fileHelper)
    {
        _fileHelper = fileHelper;
        _cachePath = DeviceInfo.Platform == DevicePlatform.Android
            ? _fileHelper.GetPublicStoragePath(Path.Combine("ReportFlow", "Caches"))
            : Path.Combine(
                Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments),
                "ReportFlow",
                "Caches");
        
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
