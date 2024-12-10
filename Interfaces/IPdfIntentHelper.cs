namespace ABFReportEditor.Interfaces;

public interface IPdfIntentHelper
{
    public Task<byte[]> GetPdfBytes(Uri uri);
}