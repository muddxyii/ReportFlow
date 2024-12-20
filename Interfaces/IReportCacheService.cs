using System.Text.Json;
using ReportFlow.Models;
using ReportFlow.Services.ReportServices;

namespace ReportFlow.Interfaces;

public interface IReportCacheService
{
    Task SaveReportAsync(ReportData report);

    Task<ReportData?> LoadReportAsync(string reportId);

    Task<IEnumerable<ReportData>> GetAllReportsAsync();

    Task DeleteReportAsync(string reportId);
}