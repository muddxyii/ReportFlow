using ABFReportEditor.Interfaces;

namespace ABFReportEditor;

public class PdfIntentHelper : IPdfIntentHelper
{
    public async Task<byte[]> GetPdfBytes(Uri uri)  // Make async
    {
        try 
        {
            var androidUri = Android.Net.Uri.Parse(uri.ToString());
            using var stream = Android.App.Application.Context.ContentResolver?.OpenInputStream(androidUri);
            if (stream != null)
            {
                using var memoryStream = new MemoryStream();
                await stream.CopyToAsync(memoryStream);
                return memoryStream.ToArray();
            }
        }
        catch (Exception ex)
        {
            System.Diagnostics.Debug.WriteLine($"Error reading PDF: {ex}");
        }
        
        return null;
    }
}