using System.ComponentModel;
using System.Windows.Input;
using ReportFlow.Interfaces;
using ReportFlow.Util;

namespace ReportFlow.ViewModels;

/// <summary>
///     Represents the base ViewModel for managing backflow-related context in the application.
///     This abstract class serves as a foundation for concrete implementations
///     of various backflow form ViewModels, providing common functionality such as form data handling,
///     PDF generation, caching, and navigation logic.
/// </summary>
/// <remarks>
///     This class implements the <see cref="System.ComponentModel.INotifyPropertyChanged" />
///     interface to notify the UI about property value changes, ensuring data binding works correctly.
/// </remarks>
public abstract class BaseBackflowViewModel : INotifyPropertyChanged
{
    #region Constructor

    /// <summary
    protected BaseBackflowViewModel(
        Dictionary<string, string> formData)
    {
        if (!formData.Any()) return;

        // Import Form Data
        SaveFormData(formData);
        NextCommand = new Command(async () => await OnNext());
        BackCommand = new Command(async () => await OnBack());

        // Get Cache Service
        _reportCacheService = IPlatformApplication.Current?.Services.GetRequiredService<IReportCacheService>() ??
                              throw new InvalidOperationException();
        // Assign Report ID If Nonexistent
        if (!FormData.ContainsKey("report_id"))
            FormData["report_id"] = Guid.NewGuid().ToString();
        else
            // Load Cached Data
            LoadCachedData();
    }

    #endregion

    #region Properties

    /// <summary>
    ///     A private, read-only instance of <see cref="IReportCacheService" /> used for managing
    ///     the caching of report data in the application. It provides core functionality such as
    ///     saving, loading, and retrieving cached report information and ensuring persistence
    ///     across various operations within the view model.
    ///     The service is initialized during the instantiation of the view model and is integral
    ///     to handling the storage and retrieval of report data, including metadata and form
    ///     information.
    ///     The cached data is loaded and updated using methods that ensure synchronization with
    ///     the service's storage, allowing seamless interaction between user operations and
    ///     report data management.
    /// </summary>
    private readonly IReportCacheService _reportCacheService;

    /// <summary>
    ///     Holds the collection of form data represented as key-value pairs.
    ///     The property is used to store application-specific form state, allowing values
    ///     to be stored, retrieved, or manipulated as needed for tasks such as form initialization,
    ///     caching, validation, and PDF generation.
    /// </summary>
    protected Dictionary<string, string> FormData { get; } = new();

    public ICommand NextCommand { get; }
    public ICommand BackCommand { get; }

    #endregion

    #region Cached Data Methods

    /// <summary>
    ///     Retrieves cached report data from the cache service asynchronously using the report ID
    ///     provided in the form data. If cached data is found, it updates the current form data
    ///     with the retrieved values.
    /// </summary>
    /// <remarks>
    ///     This method relies on the "report_id" being present in the <see cref="FormData" /> dictionary
    ///     to fetch the corresponding cached report. If data is successfully fetched from the cache,
    ///     it is merged into the existing form data.
    /// </remarks>
    /// <exception cref="InvalidOperationException">
    ///     Thrown if the form data does not contain a "report_id" key or if the cache service is
    ///     not properly configured.
    /// </exception>
    private async void LoadCachedData()
    {
        var cachedData = await _reportCacheService.LoadReportDataAsync(FormData["report_id"]);
        if (cachedData != null)
            SaveFormData(cachedData);
    }

    /// <summary>
    ///     Saves provided form data into the internal dictionary and caches it asynchronously without including the
    ///     "report_id" key.
    /// </summary>
    /// <param name="formData">The dictionary containing the form data to be saved and cached.</param>
    /// <returns>A task that represents the asynchronous operation of caching the form data.</returns>
    protected async Task SaveFormDataWithCache(Dictionary<string, string> formData)
    {
        SaveFormData(formData);
        var cacheData = new Dictionary<string, string>(FormData);
        cacheData.Remove("report_id");
        await _reportCacheService.SaveReportDataAsync(FormData["report_id"], cacheData);
    }

    #endregion

    #region Data Related Methods (Saving, Validating, etc.)

    /// <summary>
    ///     Saves the data provided in the formData dictionary to the FormData collection.
    ///     Updates or adds entries to the FormData collection with the key-value pairs from the input dictionary.
    /// </summary>
    /// <param name="formData">
    ///     A dictionary containing form data with string keys and values that need to be saved to the
    ///     FormData collection.
    /// </param>
    protected void SaveFormData(Dictionary<string, string> formData)
    {
        foreach (var form in formData) FormData[form.Key] = form.Value;
    }

    /// <summary>
    ///     Saves the form data into a PDF file using a predefined template.
    /// </summary>
    /// <param name="fileName">The name of the output PDF file to be saved.</param>
    /// <exception cref="FileNotFoundException">Thrown if the PDF template file cannot be found.</exception>
    /// <exception cref="Exception">Thrown if an error occurs while saving the PDF file.</exception>
    /// <returns>A task that represents the asynchronous save operation.</returns>
    protected async Task SavePdf(string fileName)
    {
        // Select Pdf Template
        var pdfTemplate = "ReportFlow.Resources.PdfTemplates.Abf-Fillable-12-24.pdf";
        // Load Pdf Stream
        await using var resourceStream = GetType().Assembly.GetManifestResourceStream(pdfTemplate);
        if (resourceStream == null)
            throw new FileNotFoundException("Template not found.");
        // Save PDF with form data
        await PdfUtils.GenerateAndSharePdf(resourceStream, FormData, fileName);
    }

    // Checks if field is valid, if not it creates a pop-up
    /// <summary>
    ///     Validates a collection of fields by checking if their values are filled.
    ///     Displays a pop-up alert if any field is found invalid.
    /// </summary>
    /// <param name="fieldsToCheck">
    ///     An array of tuples, where each tuple represents a field with a Value (string) and a Name (string).
    ///     The Value is checked to ensure it is not null or empty.
    /// </param>
    /// <returns>
    ///     A task representing the asynchronous operation. Returns a boolean indicating whether all fields are valid.
    ///     True if all fields have valid values; otherwise, false if at least one field is invalid.
    /// </returns>
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

    /// <summary>
    ///     Initializes the form fields by extracting and assigning values from the FormData dictionary.
    ///     This method is intended to be overridden in derived classes to handle specific initialization
    ///     requirements of the respective ViewModel. Each implementation would map relevant keys in
    ///     FormData to the properties of the respective ViewModel.
    /// </summary>
    /// <remarks>
    ///     The FormData dictionary contains form data provided to the ViewModel, typically populated
    ///     from an external source, such as a database or an API. This method ensures that required
    ///     properties of the ViewModel are set based on the available data.
    ///     If the FormData dictionary is null or does not contain the expected keys, the implementation
    ///     should gracefully handle the corresponding property assignments and avoid runtime exceptions.
    /// </remarks>
    /// <example>
    ///     This method should contain ViewModel-specific logic in overridden implementations to map
    ///     FormData entries to properties. For example, in a derived class, a key like "Email" in
    ///     FormData might be used to set an Email property.
    /// </example>
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