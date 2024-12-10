using ABFReportEditor.Interfaces;

namespace ABFReportEditor;

public class FileHandlingService : IFileHandlingService
{
    public async Task HandleFileAsync(string filePath)
    {
        // Implement your PDF handling logic here
        await Task.CompletedTask;
    }
}