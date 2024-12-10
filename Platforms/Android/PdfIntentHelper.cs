using ABFReportEditor.Interfaces;

namespace ABFReportEditor;

public class PdfIntentHelper : IPdfIntentHelper
{
    public async Task<byte[]> GetPdfBytes(Uri uri)
    {
        Android.Net.Uri androidUri = null;
        Stream stream = null;
        MemoryStream memoryStream = null;

        try 
        {
            androidUri = Android.Net.Uri.Parse(uri.ToString());
            stream = Android.App.Application.Context.ContentResolver?.OpenInputStream(androidUri);
            if (stream != null)
            {
                memoryStream = new MemoryStream();
                await stream.CopyToAsync(memoryStream);
                return memoryStream.ToArray();
            }
        }
        catch (Exception ex)
        {
            System.Diagnostics.Debug.WriteLine($"Error reading PDF: {ex}");
            throw;
        }
        finally
        {
            stream?.Dispose();
            memoryStream?.Dispose();
        }
        
        return null;
    }
}