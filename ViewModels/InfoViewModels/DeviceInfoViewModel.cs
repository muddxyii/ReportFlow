using ReportFlow.ViewModels.TestViewModels;
using DeviceInfo = ReportFlow.Models.Info.DeviceInfo;

namespace ReportFlow.ViewModels.InfoViewModels;

public class DeviceInfoViewModel : BaseBackflowViewModel
{
    private DeviceInfo _deviceInfo;

    #region Dropdown Items

    public List<string> InstallationStatusOptions { get; } = ["NEW", "EXISTING", "REPLACEMENT"];
    public List<string> ProtectionTypeOptions { get; } = ["SECONDARY / CONTAINMENT", "PRIMARY / POINT OF USE"];
    public List<string> ServiceTypeOptions { get; } = ["DOMESTIC", "IRRIGATION", "FIRE"];

    public List<string> ManufacturerOptions { get; } =
        ["WATTS", "WILKINS", "FEBCO", "AMES", "ARI", "APOLLO", "CONBRACO", "HERSEY", "FLOMATIC", "BACKFLOW DIRECT"];

    public List<string> TypeOptions { get; } = ["RP", "DC", "PVB", "SVB", "SC", "TYPE 2"];

    #endregion

    #region Location Properties

    public string? WaterPurveyor
    {
        get => _deviceInfo.Location.WaterPurveyor;
        set
        {
            _deviceInfo.Location.WaterPurveyor = value;
            OnPropertyChanged(nameof(WaterPurveyor));
        }
    }

    public string? AssemblyAddress
    {
        get => _deviceInfo.Location.AssemblyAddress;
        set
        {
            _deviceInfo.Location.AssemblyAddress = value;
            OnPropertyChanged(nameof(AssemblyAddress));
        }
    }

    public string? OnSiteLocation
    {
        get => _deviceInfo.Location.OnSiteLocation;
        set
        {
            _deviceInfo.Location.OnSiteLocation = value;
            OnPropertyChanged(nameof(OnSiteLocation));
        }
    }

    public string? PrimaryService
    {
        get => _deviceInfo.Location.PrimaryService;
        set
        {
            _deviceInfo.Location.PrimaryService = value;
            OnPropertyChanged(nameof(PrimaryService));
        }
    }

    public string? WaterMeterNo
    {
        get => _deviceInfo.Location.WaterMeterNo;
        set
        {
            _deviceInfo.Location.WaterMeterNo = value;
            OnPropertyChanged(nameof(WaterMeterNo));
            if (value == "INTERNAL") _deviceInfo.Installation.ProtectionType = "PRIMARY / POINT OF USE";
        }
    }

    #endregion

    #region Installation Properties

    public string? InstallationStatus
    {
        get => _deviceInfo.Installation.InstallationStatus;
        set
        {
            _deviceInfo.Installation.InstallationStatus = value;
            OnPropertyChanged(nameof(InstallationStatus));
        }
    }

    public string? ProtectionType
    {
        get => _deviceInfo.Installation.ProtectionType;
        set
        {
            _deviceInfo.Installation.ProtectionType = value;
            OnPropertyChanged(nameof(ProtectionType));
        }
    }

    public string? ServiceType
    {
        get => _deviceInfo.Installation.ServiceType;
        set
        {
            _deviceInfo.Installation.ServiceType = value;
            OnPropertyChanged(nameof(ServiceType));
        }
    }

    #endregion

    #region Device Properties

    public string? SerialNo
    {
        get => _deviceInfo.Device.SerialNo;
        set
        {
            _deviceInfo.Device.SerialNo = value;
            OnPropertyChanged(nameof(SerialNo));
        }
    }

    public string? ModelNo
    {
        get => _deviceInfo.Device.ModelNo;
        set
        {
            _deviceInfo.Device.ModelNo = value;
            OnPropertyChanged(nameof(ModelNo));
        }
    }

    public string? Size
    {
        get => _deviceInfo.Device.Size;
        set
        {
            _deviceInfo.Device.Size = value;
            OnPropertyChanged(nameof(Size));
        }
    }

    public string? Manufacturer
    {
        get => _deviceInfo.Device.Manufacturer;
        set
        {
            _deviceInfo.Device.Manufacturer = value;
            OnPropertyChanged(nameof(Manufacturer));
        }
    }

    public string? Type
    {
        get => _deviceInfo.Device.Type;
        set
        {
            _deviceInfo.Device.Type = value;
            OnPropertyChanged(nameof(Type));
        }
    }

    #endregion

    #region Constructor

    public DeviceInfoViewModel() : this(new Dictionary<string, string>())
    {
    }

    public DeviceInfoViewModel(Dictionary<string, string> formData) : base(formData)
    {
        _deviceInfo = DeviceInfo.FromFormFields(formData);
    }

    #endregion

    #region Navigation Methods

    protected override async Task OnNext()
    {
        if (!await AreFieldsValid(new (string Value, string Name)[]
            {
                (Type ?? "", "Backflow Type"),
                (PrimaryService ?? "", "Primary Service At Location")
            })) return;

        await SaveFormDataWithCache(_deviceInfo.ToFormFields());

        await NavigateToTestPage();
    }

    private async Task NavigateToTestPage()
    {
        var viewModelType = Type switch
        {
            "RP" => typeof(RpTestViewModel),
            "DC" => typeof(DcTestViewModel),
            "SC" => typeof(ScTestViewModel),
            "PVB" => typeof(PvbTestViewModel),
            "SVB" => typeof(SvbTestViewModel),
            _ => null
        };

        if (viewModelType == null)
        {
            await Application.Current.MainPage.DisplayAlert(
                "Not Implemented",
                $"The type '{Type}' has not been implemented.",
                "OK");
            return;
        }

        var viewModel = Activator.CreateInstance(viewModelType, FormData);
        var pageName = viewModelType.Name.Replace("ViewModel", "");

        await Shell.Current.GoToAsync(pageName, new Dictionary<string, object>
        {
            ["ViewModel"] = viewModel
        });
    }

    protected override async Task OnBack()
    {
        await SaveFormDataWithCache(_deviceInfo.ToFormFields());

        var viewModel = new CustomerInfoViewModel(FormData);
        await Shell.Current.GoToAsync("CustomerInfo", new Dictionary<string, object>
        {
            ["ViewModel"] = viewModel
        });
    }

    #endregion
}