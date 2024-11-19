using iText.Forms;
using iText.Kernel.Pdf;

namespace ABFReportEditor.Util;

public class PdfUtils
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
}