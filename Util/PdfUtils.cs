using iText.Forms;
using iText.Kernel.Pdf;
using ReportFlow.Interfaces;

namespace ReportFlow.Util;

public static class PdfUtils
{
    // Keep this method as is since it's for reading/extracting data
    public static Dictionary<string, string> ExtractPdfFormData(Stream pdfStream)
    {
        var formFields = new Dictionary<string, string>();
        using var pdfReader = new PdfReader(pdfStream);
        using var pdfDoc = new PdfDocument(pdfReader);

        var form = PdfAcroForm.GetAcroForm(pdfDoc, false);
        if (form != null)
        {
            var fields = form.GetAllFormFields();
            foreach (var field in fields) formFields[field.Key] = field.Value.GetValueAsString();
        }

        return formFields;
    }

    public static async Task GenerateAndSharePdf(Stream pdfTemplateStream,
        Dictionary<string, string> formData,
        string fileName)
    {
        try
        {
            using var outputStream = new MemoryStream();

            // Create PDF reader and writer directly from the input stream
            var reader = new PdfReader(pdfTemplateStream);
            var writer = new PdfWriter(outputStream);
            var pdfDoc = new PdfDocument(reader, writer);

            // Get the form from the PDF
            var form = PdfAcroForm.GetAcroForm(pdfDoc, true);

            // Clear existing form fields
            foreach (var field in form.GetAllFormFields())
            {
                var fieldType = field.Value.GetFormType();
                switch (fieldType.ToString())
                {
                    case "/Tx":
                        field.Value.SetValue("");
                        break;
                    case "/Ch":
                        field.Value.SetValue("");
                        break;
                    case "/Btn":
                        field.Value.SetValue("Off");
                        break;
                }
            }

            form.SetNeedAppearances(true);
            foreach (var field in formData)
            {
                var pdfField = form.GetField(field.Key);
                if (pdfField != null)
                {
                    pdfField.SetValue(field.Value);
                    pdfField.SetFontSizeAutoScale();
                    pdfField.RegenerateField();
                }
            }

            pdfDoc.Close();

            // Write to temporary cache file for sharing
            var tempFile = Path.Combine(FileSystem.Current.CacheDirectory, fileName);
            await File.WriteAllBytesAsync(tempFile, outputStream.ToArray());

            // Share immediately
            await MainThread.InvokeOnMainThreadAsync(async () =>
            {
                await Share.RequestAsync(new ShareFileRequest
                {
                    Title = "Share PDF",
                    File = new ShareFile(tempFile)
                });
            });
        }
        catch (Exception ex)
        {
            await MainThread.InvokeOnMainThreadAsync(async () =>
            {
                await Application.Current.MainPage.DisplayAlert(
                    "Error",
                    $"Failed to generate PDF: {ex.Message}",
                    "OK");
            });
        }
    }
}