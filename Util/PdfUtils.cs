using ABFReportEditor.Interfaces;
using iText.Forms;
using iText.Kernel.Pdf;

namespace ABFReportEditor.Util;

public static class PdfUtils
{
    public static Dictionary<string, string> ExtractPdfFormData(byte[] pdfBytes)
    {
        var formFields = new Dictionary<string, string>();
        using var memoryStream = new MemoryStream(pdfBytes);
        using var pdfReader = new PdfReader(memoryStream);
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
            baseDirectory = fileHelper?.GetPublicStoragePath("Reports");
        }
        else
        {
            // Use Documents folder on Windows
            baseDirectory = Path.Combine(
                Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments),
                "Reports");
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

    public static async Task SavePdfWithFormData(byte[] originalPdf,
        Dictionary<string, string> formData,
        string fileName)
    {
        try
        {
            // Create a memory stream for the PDF manipulation
            using var inputStream = new MemoryStream(originalPdf);
            using var outputStream = new MemoryStream();

            // Create PDF reader and writer
            var reader = new PdfReader(inputStream);
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

            // Update all form fields
            foreach (var field in formData)
            {
                if (form.GetField(field.Key) != null)
                {
                    form.GetField(field.Key).SetValue(field.Value);
                }
            }

            // Close the document to apply changes
            pdfDoc.Close();

            // Get platform-specific file path
            string filePath = GetPdfStoragePath(fileName);

            // Write the file
            await File.WriteAllBytesAsync(filePath, outputStream.ToArray());

            // Get a friendly path to display to the user
            string displayPath = DeviceInfo.Platform == DevicePlatform.Android
                ? $"Reports/{Path.GetFileName(filePath)}"
                : filePath;

            // Notify the user
            await MainThread.InvokeOnMainThreadAsync(async () =>
            {
                await Application.Current.MainPage.DisplayAlert(
                    "Success",
                    $"PDF saved to: {displayPath}",
                    "OK");
            });
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