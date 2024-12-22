using System.ComponentModel;
using System.Windows.Input;

namespace ReportFlow.ViewModels.SettingsViewModel;

public class SettingsViewModel : INotifyPropertyChanged
{
    #region Private Fields

    private string _testerName;
    private string _testKitSerial;
    private string _testCertNo;
    private string _repairCertNo;
    private ICommand _saveCommand;

    #endregion

    #region Public Properties

    public string TesterName
    {
        get => _testerName;
        set
        {
            _testerName = value;
            OnPropertyChanged(nameof(TesterName));
        }
    }

    public string TestKitSerial
    {
        get => _testKitSerial;
        set
        {
            _testKitSerial = value;
            OnPropertyChanged(nameof(TestKitSerial));
        }
    }

    public string TestCertNo
    {
        get => _testCertNo;
        set
        {
            _testCertNo = value;
            OnPropertyChanged(nameof(TestCertNo));
        }
    }

    public string RepairCertNo
    {
        get => _repairCertNo;
        set
        {
            _repairCertNo = value;
            OnPropertyChanged(nameof(RepairCertNo));
        }
    }

    public ICommand SaveCommand => _saveCommand ??= new Command(async () => await Save());

    #endregion

    #region Constructor and Initialization

    public SettingsViewModel()
    {
        LoadSaveSettings();
    }

    public void LoadSaveSettings()
    {
        TesterName = Preferences.Get(nameof(TesterName), string.Empty);
        TestKitSerial = Preferences.Get(nameof(TestKitSerial), string.Empty);
        TestCertNo = Preferences.Get(nameof(TestCertNo), string.Empty);
        RepairCertNo = Preferences.Get(nameof(RepairCertNo), string.Empty);
    }

    #endregion

    #region Commands Implementation

    private async Task Save()
    {
        try
        {
            Preferences.Default.Set("TesterName", TesterName);
            Preferences.Default.Set("TestKitSerial", TestKitSerial);
            Preferences.Default.Set("CertNo", TestCertNo);
            Preferences.Default.Set("RepairCertNo", RepairCertNo);

            await Shell.Current.DisplayAlert("Success", "Settings saved successfully", "OK");
        }
        catch
        {
            await Shell.Current.DisplayAlert("Error", "Failed to save settings", "OK");
        }
    }

    #endregion

    #region INotifyPropertyChanged Implementation

    public event PropertyChangedEventHandler? PropertyChanged;

    protected void OnPropertyChanged(string propertyName)
    {
        PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
    }

    #endregion
}