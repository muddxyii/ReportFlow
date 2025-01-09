using System.IO.Compression;
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
            var pdfBytes = await GenerateEditablePdf(pdfTemplateStream, formData);
            var pdfPath = Path.Combine(FileSystem.Current.CacheDirectory, fileName);

            if (File.Exists(pdfPath)) File.Delete(pdfPath);
            await File.WriteAllBytesAsync(pdfPath, pdfBytes);

            await MainThread.InvokeOnMainThreadAsync(async () =>
            {
                await Share.RequestAsync(new ShareFileRequest
                {
                    Title = "Share PDF",
                    File = new ShareFile(pdfPath)
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

    public static async Task GenerateAndSharePdfs(Stream pdfTemplateStream,
        Dictionary<string, string> formData,
        string fileName)
    {
        try
        {
            var editablePdfBytes = await GenerateEditablePdf(pdfTemplateStream, formData);
            pdfTemplateStream.Position = 0;
            var flattenedPdfBytes = await GenerateFlattenedPdf(pdfTemplateStream, formData);

            // Create zip file in cache directory
            var zipPath = Path.Combine(FileSystem.Current.CacheDirectory,
                $"{Path.GetFileNameWithoutExtension(fileName)}.zip");
            if (File.Exists(zipPath)) File.Delete(zipPath);
            using (var zipArchive = ZipFile.Open(zipPath, ZipArchiveMode.Create))
            {
                // Add both PDFs to zip
                var editableEntry = zipArchive.CreateEntry($"editable_{fileName}");
                using (var entryStream = editableEntry.Open())
                {
                    await entryStream.WriteAsync(editablePdfBytes);
                }

                var flattenedEntry = zipArchive.CreateEntry($"flattened_{fileName}");
                using (var entryStream = flattenedEntry.Open())
                {
                    await entryStream.WriteAsync(flattenedPdfBytes);
                }
            }

            // Share zip file
            await MainThread.InvokeOnMainThreadAsync(async () =>
            {
                await Share.RequestAsync(new ShareFileRequest
                {
                    Title = "Share PDFs",
                    File = new ShareFile(zipPath)
                });
            });
        }
        catch (Exception ex)
        {
            await MainThread.InvokeOnMainThreadAsync(async () =>
            {
                await Application.Current.MainPage.DisplayAlert(
                    "Error",
                    $"Failed to generate PDFs: {ex.Message}",
                    "OK");
            });
        }
    }

    private static async Task<byte[]> GenerateEditablePdf(Stream pdfTemplateStream, Dictionary<string, string> formData)
    {
        using var outputStream = new MemoryStream();
        var reader = new PdfReader(pdfTemplateStream);
        var writer = new PdfWriter(outputStream);
        var pdfDoc = new PdfDocument(reader, writer);

        var form = PdfAcroForm.GetAcroForm(pdfDoc, true);
        ClearFormFields(form);

        form.SetNeedAppearances(true);
        PopulateFormFields(form, formData);

        pdfDoc.Close();
        return outputStream.ToArray();
    }

    private static async Task<byte[]> GenerateFlattenedPdf(Stream pdfTemplateStream,
        Dictionary<string, string> formData)
    {
        using var outputStream = new MemoryStream();
        var reader = new PdfReader(pdfTemplateStream);
        var writer = new PdfWriter(outputStream);
        var pdfDoc = new PdfDocument(reader, writer);

        var form = PdfAcroForm.GetAcroForm(pdfDoc, true);
        ClearFormFields(form);

        form.SetNeedAppearances(true);
        PopulateFormFields(form, formData);

        // Flatten the form
        form.FlattenFields();

        pdfDoc.Close();
        return outputStream.ToArray();
    }

    private static void ClearFormFields(PdfAcroForm form)
    {
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
    }

    private static void PopulateFormFields(PdfAcroForm form, Dictionary<string, string> formData)
    {
        foreach (var field in formData)
        {
            var pdfField = form.GetField(field.Key);
            if (pdfField != null)
            {
                pdfField.SetValue(field.Value);
                pdfField.SetFontSizeAutoScale();
                pdfField.SetFontSize(10f);
                pdfField.RegenerateField();
            }
        }
    }
}