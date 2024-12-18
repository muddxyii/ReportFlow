using System.ComponentModel;
using System.Windows.Input;
using ReportFlow.Interfaces;
using ReportFlow.Util;

namespace ReportFlow.ViewModels;

public abstract class BaseBackflowViewModel : INotifyPropertyChanged
{
    #region Properties

    private readonly IReportCacheService _reportCacheService;
    protected Dictionary<string, string> FormData { get; } = new Dictionary<string, string>();

    public ICommand NextCommand { get; }

    #endregion

    #region Constructor

    protected BaseBackflowViewModel(
        Dictionary<string, string> formData)
    {
        if (!formData.Any()) return;

        // Import Form Data
        SaveFormData(formData);
        NextCommand = new Command(async () => await OnNext());

        // Get Cache Service
        _reportCacheService = IPlatformApplication.Current?.Services.GetRequiredService<IReportCacheService>() ??
                              throw new InvalidOperationException();

        // Assign Report ID If Nonexistent
        if (!FormData.ContainsKey("report_id"))
            FormData["report_id"] = Guid.NewGuid().ToString();

        // Load Cached Data
        LoadCachedData();
    }

    #endregion

    #region Cached Data Methods

    private async void LoadCachedData()
    {
        var cachedData = await _reportCacheService.LoadReportDataAsync(FormData["report_id"]);
        if (cachedData != null)
            SaveFormData(cachedData);
    }

    protected async Task SaveFormDataWithCache(Dictionary<string, string> formData)
    {
        SaveFormData(formData);
        var cacheData = new Dictionary<string, string>(FormData);
        cacheData.Remove("report_id");
        await _reportCacheService.SaveReportDataAsync(FormData["report_id"], cacheData);
    }

    #endregion

    #region Data Related Methods (Saving, Validating, etc.)

    protected void SaveFormData(Dictionary<string, string> formData)
    {
        foreach (var form in formData)
        {
            FormData[form.Key] = form.Value;
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
                    $"'{field.Name}' must be filled.",
                    "OK"
                );

                return false;
            }
        }

        return true;
    }

    #endregion

    #region Abstract methods

    protected virtual void InitFormFields()
    {
    }

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