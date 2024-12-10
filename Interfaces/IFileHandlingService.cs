namespace ABFReportEditor.Interfaces;

public interface IFileHandlingService
{
    Task HandleFileAsync(string filePath);
}