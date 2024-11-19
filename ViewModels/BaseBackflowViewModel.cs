using System.ComponentModel;
using System.Windows.Input;
using ABFReportEditor.Util;

namespace ABFReportEditor.ViewModels;

public abstract class BaseBackflowViewModel : INotifyPropertyChanged
{
    private byte[]? _pdfData;
    
    // Common PDF data handling
    public byte[]? PdfData
    {
        get => _pdfData;
        set
        {
            _pdfData = value;
            OnPropertyChanged(nameof(PdfData));
        }
    }

    // Common command for navigation
    public ICommand NextCommand { get; }

    protected BaseBackflowViewModel()
    {
        NextCommand = new Command(async () => await OnNext());
    }

    // Common PDF loading logic with template method pattern
    public void LoadPdfData(byte[] pdfBytes)
    {
        PdfData = pdfBytes;
        var formFields = PdfUtils.ExtractPdfFormData(pdfBytes);
        LoadFormFields(formFields);
    }

    // Template method to be implemented by derived classes
    protected abstract void LoadFormFields(Dictionary<string, string> formFields);
    
    // Template method for navigation logic
    protected abstract Task OnNext();

    // INotifyPropertyChanged Implementation
    public event PropertyChangedEventHandler? PropertyChanged;
    
    protected void OnPropertyChanged(string propertyName)
    {
        PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
    }
}