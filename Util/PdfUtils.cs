using iText.Forms;
using iText.Kernel.Pdf;
using ReportFlow.Interfaces;

namespace ReportFlow.Util;

public static class PdfUtils
{
    // Returns form fields
    public static Dictionary<string, string> ExtractPdfFormData(Stream pdfStream)
    {
        var formFields = new Dictionary<string, string>();
        using var pdfReader = new PdfReader(pdfStream);
        using var pdfDoc = new PdfDocument(pdfReader);

        var form = PdfAcroForm.GetAcroForm(pdfDoc, false);
        if (form != null)
        {
            var fields = form.GetAllFormFields();
            foreach (var field in fields)
            {
                formFields[field.Key] = field.Value.GetValueAsString();
            }
        }
        return formFields;
    }

    private static string GetPdfStoragePath(string fileName)
    {
        string baseDirectory;

        if (DeviceInfo.Platform == DevicePlatform.Android)
        {
            // Use app-specifict external storage on Android
            var fileHelper = IPlatformApplication.Current?.Services.GetService<IFileHelper>();
            baseDirectory = fileHelper?.GetPublicStoragePath("ReportFlow");
        }
        else
        {
            // Use Documents folder on Windows
            baseDirectory = Path.Combine(
                Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments),
                "ReportFlow");
        }

        // Ensure the directory exists
        Directory.CreateDirectory(baseDirectory);

        // Generate unique filename
        string fileNameWithoutExt = Path.GetFileNameWithoutExtension(fileName);
        string extension = Path.GetExtension(fileName);
        string filePath = Path.Combine(baseDirectory, fileName);
        int counter = 1;

        while (File.Exists(filePath))
        {
            filePath = Path.Combine(baseDirectory,
                $"{fileNameWithoutExt}_{counter}{extension}");
            counter++;
        }

        return filePath;
    }

    public static async Task SavePdfWithFormData(Stream pdfTemplateStream,
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

            // The rest remains the same
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

            string filePath = GetPdfStoragePath(fileName);
            await File.WriteAllBytesAsync(filePath, outputStream.ToArray());

            string displayPath = DeviceInfo.Platform == DevicePlatform.Android
                ? $"ReportFlow/{Path.GetFileName(filePath)}"
                : filePath;

            if (DeviceInfo.Platform == DevicePlatform.Android)
            {
                await MainThread.InvokeOnMainThreadAsync(async () =>
                {
                    var action = await Application.Current.MainPage.DisplayActionSheet(
                        $"PDF saved to: {displayPath}",
                        "Ok",
                        null,
                        "Click to Share");

                    if (action == "Click to Share")
                    {
                        await Share.RequestAsync(new ShareFileRequest
                        {
                            Title = "Share PDF",
                            File = new ShareFile(filePath)
                        });
                    }
                });
            }
            else
            {
                await MainThread.InvokeOnMainThreadAsync(async () =>
                {
                    await Application.Current.MainPage.DisplayAlert(
                        "Success",
                        $"PDF saved to: {displayPath}",
                        "OK");
                });
            }
        }
        catch (Exception ex)
        {
            await MainThread.InvokeOnMainThreadAsync(async () =>
            {
                await Application.Current.MainPage.DisplayAlert(
                    "Error",
                    $"Failed to save PDF: {ex.Message}",
                    "OK");
            });
        }
    }
}