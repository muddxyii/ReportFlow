namespace ReportFlow.Interfaces;

public interface IPdfIntentHelper
{
    public Task<Stream> GetPdfStream(Uri uri);
}