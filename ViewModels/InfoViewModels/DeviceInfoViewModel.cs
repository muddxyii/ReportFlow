using ReportFlow.ViewModels.TestViewModels;

namespace ReportFlow.ViewModels.InfoViewModels;

public class DeviceInfoViewModel : BaseBackflowViewModel
{
    #region Dropdown Items

    public List<string> InstallationStatusOptions { get; } =
        ["NEW", "EXISTING", "REPLACEMENT"];

    public List<string> ProtectionTypeOptions { get; } =
        ["SECONDARY / CONTAINMENT", "PRIMARY / POINT OF USE"];

    public List<string> ServiceTypeOptions { get; } =
        ["DOMESTIC", "IRRIGATION", "FIRE"];

    public List<string> ManufacturerOptions { get; } =
    [
        "WATTS", "WILKINS", "FEBCO", "AMES", "ARI", "APOLLO",
        "CONBRACO", "HERSEY", "FLOMATIC", "BACKFLOW DIRECT"
    ];

    public List<string> TypeOptions { get; } =
        ["RP", "DC", "PVB", "SVB", "SC", "TYPE 2"];

    #endregion

    #region Private Properties

    private string? _waterPurveyor;
    private string? _assemblyAddress;
    private string? _onSiteLocation;
    private string? _primaryService;
    private string? _installationStatus;
    private string? _protectionType;
    private string? _serviceType;
    private string? _waterMeterNo;
    private string? _serialNo;
    private string? _modelNo;
    private string? _size;
    private string? _manufacturer;
    private string? _type;

    #endregion

    #region Public Properties

    public string? WaterPurveyor
    {
        get => _waterPurveyor;
        set
        {
            _waterPurveyor = value;
            OnPropertyChanged(nameof(WaterPurveyor));
        }
    }

    public string? AssemblyAddress
    {
        get => _assemblyAddress;
        set
        {
            _assemblyAddress = value;
            OnPropertyChanged(nameof(AssemblyAddress));
        }
    }

    public string? OnSiteLocation
    {
        get => _onSiteLocation;
        set
        {
            _onSiteLocation = value;
            OnPropertyChanged(nameof(OnSiteLocation));
        }
    }

    public string? PrimaryService
    {
        get => _primaryService;
        set
        {
            _primaryService = value;
            OnPropertyChanged(nameof(PrimaryService));
        }
    }

    public string? InstallationStatus
    {
        get => _installationStatus;
        set
        {
            _installationStatus = value;
            OnPropertyChanged(nameof(InstallationStatus));
        }
    }

    public string? ServiceType
    {
        get => _serviceType;
        set
        {
            _serviceType = value;
            OnPropertyChanged(nameof(ServiceType));
        }
    }

    public string? ProtectionType
    {
        get => _protectionType;
        set
        {
            _protectionType = value;
            OnPropertyChanged(nameof(ProtectionType));
        }
    }

    public string? WaterMeterNo
    {
        get => _waterMeterNo;
        set
        {
            _waterMeterNo = value;
            OnPropertyChanged(nameof(WaterMeterNo));

            if (value == "INTERNAL") ProtectionType = "PRIMARY / POINT OF USE";
        }
    }

    public string? SerialNo
    {
        get => _serialNo;
        set
        {
            _serialNo = value;
            OnPropertyChanged(nameof(SerialNo));
        }
    }

    public string? ModelNo
    {
        get => _modelNo;
        set
        {
            _modelNo = value;
            OnPropertyChanged(nameof(ModelNo));
        }
    }

    public string? Size
    {
        get => _size;
        set
        {
            _size = value;
            OnPropertyChanged(nameof(Size));
        }
    }

    public string? Manufacturer
    {
        get => _manufacturer;
        set
        {
            _manufacturer = value;
            OnPropertyChanged(nameof(Manufacturer));
        }
    }

    public string? Type
    {
        get => _type;
        set
        {
            _type = value;
            OnPropertyChanged(nameof(Type));
        }
    }

    #endregion

    #region Constructor

    public DeviceInfoViewModel(Dictionary<string, string>? formData) : base(formData)
    {
        InitFormFields();
    }

    protected sealed override void InitFormFields()
    {
        if (FormData == null) return;

        WaterPurveyor = FormData.GetValueOrDefault("WaterPurveyor");
        AssemblyAddress = FormData.GetValueOrDefault("AssemblyAddress");
        OnSiteLocation = FormData.GetValueOrDefault("On Site Location of Assembly");
        PrimaryService = FormData.GetValueOrDefault("PrimaryBusinessService");
        InstallationStatus = FormData.GetValueOrDefault("InstallationIs");
        ProtectionType = FormData.GetValueOrDefault("ProtectionType");
        ServiceType = FormData.GetValueOrDefault("ServiceType");
        WaterMeterNo = FormData.GetValueOrDefault("WaterMeterNo");
        SerialNo = FormData.GetValueOrDefault("SerialNo");
        ModelNo = FormData.GetValueOrDefault("ModelNo");
        Size = FormData.GetValueOrDefault("Size");
        Manufacturer = FormData.GetValueOrDefault("Manufacturer");
        Type = FormData.GetValueOrDefault("BFType");
    }

    #endregion

    #region Abstract Methods

    private Dictionary<string, string> GetFormFields()
    {
        var formFields = new Dictionary<string, string>()
        {
            { "WaterPurveyor", WaterPurveyor ?? string.Empty },
            { "AssemblyAddress", AssemblyAddress ?? string.Empty },
            { "On Site Location of Assembly", OnSiteLocation ?? string.Empty },
            { "PrimaryBusinessService", PrimaryService ?? string.Empty },
            { "InstallationIs", InstallationStatus ?? string.Empty },
            { "ProtectionType", ProtectionType ?? string.Empty },
            { "ServiceType", ServiceType ?? string.Empty },
            { "WaterMeterNo", WaterMeterNo ?? string.Empty },
            { "SerialNo", SerialNo ?? string.Empty },
            { "ModelNo", ModelNo ?? string.Empty },
            { "Size", Size ?? string.Empty },
            { "Manufacturer", Manufacturer ?? string.Empty },
            { "BFType", Type ?? string.Empty }
        };

        return formFields;
    }

    protected override async Task OnNext()
    {
        // Check if the necessary fields were filled
        if (!await AreFieldsValid(new (string Value, string Name)[]
            {
                (Type ?? "", "Backflow Type"),
                (PrimaryService ?? "", "Primary Service At Location")
            })) return;

        // Save form fields to form data
        var formFields = GetFormFields();
        await SaveFormDataWithCache(formFields);

        // Load next viewmodel
        switch (Type)
        {
            case "RP":
                var rpViewModel = new RpTestViewModel(FormData);
                await Shell.Current.GoToAsync("RpTest", new Dictionary<string, object>
                {
                    { "ViewModel", rpViewModel }
                });
                break;
            case "DC":
                var dcViewModel = new DcTestViewModel(FormData);
                await Shell.Current.GoToAsync("DcTest", new Dictionary<string, object>
                {
                    { "ViewModel", dcViewModel }
                });
                break;
            case "SC":
                var scViewModel = new ScTestViewModel(FormData);
                await Shell.Current.GoToAsync("ScTest", new Dictionary<string, object>
                {
                    { "ViewModel", scViewModel }
                });
                break;
            case "PVB":
                var pvbViewModel = new PvbTestViewModel(FormData);
                await Shell.Current.GoToAsync("PvbTest", new Dictionary<string, object>
                {
                    { "ViewModel", pvbViewModel }
                });
                break;
            case "SVB":
                var svbViewModel = new SvbTestViewModel(FormData);
                await Shell.Current.GoToAsync("SvbTest", new Dictionary<string, object>
                {
                    { "ViewModel", svbViewModel }
                });
                break;
            case "TYPE 2":
                await Application.Current.MainPage.DisplayAlert(
                    "Not Implemented",
                    $"The type '{Type}' has not been implemented.",
                    "OK"
                );
                break;
            default:
                await Application.Current.MainPage.DisplayAlert(
                    "Not Implemented",
                    $"The type '{Type}' has not been implemented.",
                    "OK"
                );
                break;
        }
    }

    protected override async Task OnBack()
    {
        // Save form fields to form data
        var formFields = GetFormFields();
        await SaveFormDataWithCache(formFields);

        var viewModel = new CustomerInfoViewModel(FormData);
        await Shell.Current.GoToAsync("CustomerInfo", new Dictionary<string, object>
        {
            ["ViewModel"] = viewModel
        });
    }

    #endregion

    public DeviceInfoViewModel() : this(new Dictionary<string, string>())
    {
    }
}