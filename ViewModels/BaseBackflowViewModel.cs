using System.ComponentModel;
using System.Windows.Input;
using ReportFlow.Util;

namespace ReportFlow.ViewModels;

public abstract class BaseBackflowViewModel : INotifyPropertyChanged
{
    #region Properties
    
    protected Dictionary<string, string>? FormData { get; } = new Dictionary<string, string>();
    
    public ICommand NextCommand { get; }
    
    #endregion

    #region Constructor

    protected BaseBackflowViewModel(Dictionary<string, string>? formData)
    {
        // SaveFormData
        SaveFormData(formData ?? new Dictionary<string, string>());
        
        // Register Next Command
        NextCommand = new Command(async () => await OnNext());
    }
    
    #endregion

    #region Data Related Methods (Saving, Validating, etc.)

    protected void SaveFormData(Dictionary<string, string> formData)
    {
        foreach (var form in formData)
        {
            if (FormData != null) FormData[form.Key] = form.Value;
        }
    }
    
    protected async Task SavePdf(string fileName)
    {
        // Select Pdf Template
        var pdfTemplate = "ReportFlow.Resources.PdfTemplates.Abf-Fillable-12-24.pdf";
        
        // Load Pdf Stream
        await using var resourceStream = GetType().Assembly.GetManifestResourceStream(pdfTemplate);
        if (resourceStream == null)
            throw new FileNotFoundException("Template not found.");

        // Save PDF with form data
        await PdfUtils.SavePdfWithFormData(resourceStream, FormData, fileName);
    }

    // Checks if field is valid, if not it creates a pop-up
    protected async Task<bool> AreFieldsValid((string Value, string Name)[] fieldsToCheck)
    {
        foreach (var field in fieldsToCheck)
        {
            if (string.IsNullOrEmpty(field.Value))
            {
                await Application.Current.MainPage.DisplayAlert(
                    "Invalid Field",
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

    protected virtual void InitFormFields() {}
    
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