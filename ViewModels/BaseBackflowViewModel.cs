using System.ComponentModel;
using System.Windows.Input;
using ReportFlow.Interfaces;
using ReportFlow.Models;
using ReportFlow.Util;

namespace ReportFlow.ViewModels;

public abstract class BaseBackflowViewModel : INotifyPropertyChanged
{
    protected readonly IReportCacheService _reportCacheService;
    protected ReportData Report { get; private set; }

    public ICommand NextCommand { get; }
    public ICommand BackCommand { get; }

    #region Constructor

    protected BaseBackflowViewModel(ReportData reportData)
    {
        // Get Cache Service
        _reportCacheService = IPlatformApplication.Current?.Services.GetRequiredService<IReportCacheService>() ??
                              throw new InvalidOperationException();

        Report = reportData;

        NextCommand = new Command(async () => await OnNext());
        BackCommand = new Command(async () => await OnBack());
    }

    #endregion

    #region Report Handling

    protected async Task SaveReport()
    {
        await _reportCacheService.SaveReportAsync(Report);
    }

    protected async Task ShareReportAsPdf(string fileName)
    {
        // Select Pdf Template
        var pdfTemplate = "ReportFlow.Resources.PdfTemplates.Abf-Fillable-12-24.pdf";

        // Load Pdf Stream
        await using var resourceStream = GetType().Assembly.GetManifestResourceStream(pdfTemplate);
        if (resourceStream == null)
            throw new FileNotFoundException("Template not found.");

        // Gen PDF with form data
        await PdfUtils.GenerateAndSharePdf(resourceStream, Report.ToFormFields(), fileName);
    }

    #endregion

    #region Data Related Methods (Saving, Validating, etc.)

    protected async Task<bool> AreFieldsValid((string Value, string Name)[] fieldsToCheck)
    {
        foreach (var field in fieldsToCheck)
            if (string.IsNullOrEmpty(field.Value))
            {
                await Application.Current.MainPage.DisplayAlert(
                    "Invalid Field",
                    $"'{field.Name}' must be filled.",
                    "OK"
                );
                return false;
            }

        return true;
    }

    #endregion

    #region Abstract methods

    protected virtual void InitFormFields()
    {
    }

    protected abstract Task OnNext();
    protected abstract Task OnBack();

    #endregion

    #region INotifyPropertyChanged Implementation

    /// <summary>
    ///     An event that is triggered whenever a property value changes within the implementing object.
    ///     Typically used to notify UI elements or other components of property changes in support of data binding.
    ///     Implements the <see cref="INotifyPropertyChanged" /> interface.
    /// </summary>
    public event PropertyChangedEventHandler? PropertyChanged;

    /// <summary>
    ///     Notifies subscribers that a property value has changed.
    /// </summary>
    /// <param name="propertyName">The name of the property that changed.</param>
    protected void OnPropertyChanged(string propertyName)
    {
        PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
    }

    #endregion
}