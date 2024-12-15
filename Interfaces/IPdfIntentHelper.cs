namespace ReportFlow.Interfaces;

public interface IPdfIntentHelper
{
    public Task<byte[]> GetPdfBytes(Uri uri);
}