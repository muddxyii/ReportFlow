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
            
            // Get the file path
            string documentsPath = Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments);
            string filePath = Path.Combine(documentsPath, fileName);
            
            // Ensure unique filename
            int counter = 1;
            string fileNameWithoutExt = Path.GetFileNameWithoutExtension(fileName);
            string extension = Path.GetExtension(fileName);
            
            while (File.Exists(filePath))
            {
                filePath = Path.Combine(documentsPath, 
                    $"{fileNameWithoutExt}_{counter}{extension}");
                counter++;
            }
            
            // Write the file
            await File.WriteAllBytesAsync(filePath, outputStream.ToArray());
            
            // Optionally notify the user
            await Application.Current.MainPage.DisplayAlert(
                "Success", 
                $"PDF saved to: {filePath}", 
                "OK");
        }
        catch (Exception ex)
        {
            await Application.Current.MainPage.DisplayAlert(
                "Error", 
                $"Failed to save PDF: {ex.Message}", 
                "OK");
        }
    }
}