using System.ComponentModel;
using System.Windows.Input;
using ABFReportEditor.Util;

namespace ABFReportEditor.ViewModels;

public abstract class BaseBackflowViewModel : INotifyPropertyChanged
{
    #region Properties
    public Dictionary<string, string>? FormData { get; set; } = new Dictionary<string, string>();
    private byte[]? _pdfData;
    
    public byte[]? PdfData
    {
        get => _pdfData;
        set
        {
            _pdfData = value;
            OnPropertyChanged(nameof(PdfData));
        }
    }
    
    public ICommand NextCommand { get; }
    
    #endregion

    #region Constructor

    protected BaseBackflowViewModel()
    {
        NextCommand = new Command(async () => await OnNext());
    }
    
    #endregion

    #region Data loading and saving methods
    
    public void LoadPdfData(byte[] pdfBytes)
    {
        PdfData = pdfBytes;
        var formFields = PdfUtils.ExtractPdfFormData(pdfBytes);
        LoadFormFields(formFields);
    }

    public void LoadPdfData(byte[] pdfBytes, Dictionary<string, string> formData)
    {
        // Load PdfBytes
        PdfData = pdfBytes;
        var formFields = PdfUtils.ExtractPdfFormData(pdfBytes);
        LoadFormFields(formFields);
        
        SaveFormData(formData);
    }

    protected void SaveFormData(Dictionary<string, string> formFields)
    {
        foreach (var form in formFields)
        {
            if (FormData != null) FormData[form.Key] = form.Value;
        }
    }
    
    protected async Task SavePdf(string fileName)
    {
        await PdfUtils.SavePdfWithFormData(PdfData, FormData, fileName);
    }

    protected async Task<bool> AreFieldsValid((string Value, string Name)[] fieldsToCheck)
    {
        foreach (var field in fieldsToCheck)
        {
            if (string.IsNullOrEmpty(field.Value))
            {
                await Application.Current.MainPage.DisplayAlert(
                    "Not a valid field",
                    $"Please fill '{field.Name}'.",
                    "OK"
                );

                return false;
            }
        }

        return true;
    }
    
    #endregion
    
    #region Abstract methods
    
    protected virtual void LoadFormFields(Dictionary<string, string> formFields) {}
    
    // Template method for navigation logic
    protected abstract Task OnNext();

    #endregion
    
    #region INotifyPropertyChanged Implementation

    public event PropertyChangedEventHandler? PropertyChanged;
    
    protected void OnPropertyChanged(string propertyName)
    {
        PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
    }
    
    #endregion
}