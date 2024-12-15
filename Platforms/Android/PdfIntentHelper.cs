using ReportFlow.Interfaces;
using FileNotFoundException = Java.IO.FileNotFoundException;

namespace ReportFlow;

public class PdfIntentHelper : IPdfIntentHelper
{
    public async Task<Stream> GetPdfStream(Uri uri)
    {
        try
        {
            var androidUri = Android.Net.Uri.Parse(uri.ToString());
            var contentStream = Android.App.Application.Context.ContentResolver?.OpenInputStream(androidUri);

            if (contentStream == null)
                throw new FileNotFoundException("Could not find PDF file");

            // Create a memory stream that will hold the PDF data
            var pdfStream = new MemoryStream();
            await contentStream.CopyToAsync(pdfStream);
            await contentStream.DisposeAsync();

            // Reset position for PDF reading
            pdfStream.Position = 0;

            // Return the stream ready for PDF processing
            return pdfStream;
        }
        catch (Exception ex)
        {
            System.Diagnostics.Debug.WriteLine($"Error reading PDF: {ex}");
            throw;
        }
    }
}