using ReportFlow.Models;
using ReportFlow.ViewModels.TestViewModels;
using DeviceInfo = ReportFlow.Models.Info.DeviceInfo;

namespace ReportFlow.ViewModels.InfoViewModels;

public class DeviceInfoViewModel : BaseBackflowViewModel
{
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
        get => Report.DeviceInfo.Location.WaterPurveyor;
        set
        {
            Report.DeviceInfo.Location.WaterPurveyor = value;
            OnPropertyChanged(nameof(WaterPurveyor));
        }
    }

    public string? AssemblyAddress
    {
        get => Report.DeviceInfo.Location.AssemblyAddress;
        set
        {
            Report.DeviceInfo.Location.AssemblyAddress = value;
            OnPropertyChanged(nameof(AssemblyAddress));
        }
    }

    public string? OnSiteLocation
    {
        get => Report.DeviceInfo.Location.OnSiteLocation;
        set
        {
            Report.DeviceInfo.Location.OnSiteLocation = value;
            OnPropertyChanged(nameof(OnSiteLocation));
        }
    }

    public string? PrimaryService
    {
        get => Report.DeviceInfo.Location.PrimaryService;
        set
        {
            Report.DeviceInfo.Location.PrimaryService = value;
            OnPropertyChanged(nameof(PrimaryService));
        }
    }

    public string? WaterMeterNo
    {
        get => Report.DeviceInfo.Location.WaterMeterNo;
        set
        {
            Report.DeviceInfo.Location.WaterMeterNo = value;
            OnPropertyChanged(nameof(WaterMeterNo));
            if (value == "INTERNAL") Report.DeviceInfo.Installation.ProtectionType = "PRIMARY / POINT OF USE";
        }
    }

    #endregion

    #region Installation Properties

    public string? InstallationStatus
    {
        get => Report.DeviceInfo.Installation.InstallationStatus;
        set
        {
            Report.DeviceInfo.Installation.InstallationStatus = value;
            OnPropertyChanged(nameof(InstallationStatus));
        }
    }

    public string? ProtectionType
    {
        get => Report.DeviceInfo.Installation.ProtectionType;
        set
        {
            Report.DeviceInfo.Installation.ProtectionType = value;
            OnPropertyChanged(nameof(ProtectionType));
        }
    }

    public string? ServiceType
    {
        get => Report.DeviceInfo.Installation.ServiceType;
        set
        {
            Report.DeviceInfo.Installation.ServiceType = value;
            OnPropertyChanged(nameof(ServiceType));
        }
    }

    #endregion

    #region Device Properties

    public string? SerialNo
    {
        get => Report.DeviceInfo.Device.SerialNo;
        set
        {
            Report.DeviceInfo.Device.SerialNo = value;
            OnPropertyChanged(nameof(SerialNo));
        }
    }

    public string? ModelNo
    {
        get => Report.DeviceInfo.Device.ModelNo;
        set
        {
            Report.DeviceInfo.Device.ModelNo = value;
            OnPropertyChanged(nameof(ModelNo));
        }
    }

    public string? Size
    {
        get => Report.DeviceInfo.Device.Size;
        set
        {
            Report.DeviceInfo.Device.Size = value;
            OnPropertyChanged(nameof(Size));
        }
    }

    public string? Manufacturer
    {
        get => Report.DeviceInfo.Device.Manufacturer;
        set
        {
            Report.DeviceInfo.Device.Manufacturer = value;
            OnPropertyChanged(nameof(Manufacturer));
        }
    }

    public string? Type
    {
        get => Report.DeviceInfo.Device.Type;
        set
        {
            Report.DeviceInfo.Device.Type = value;
            OnPropertyChanged(nameof(Type));
        }
    }

    #endregion

    #region Constructor

    public DeviceInfoViewModel() : this(new ReportData())
    {
        Report.DeviceInfo = new DeviceInfo();
    }

    public DeviceInfoViewModel(ReportData reportData) : base(reportData)
    {
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

        await SaveReport();

        await NavigateToTestPage();
    }

    private async Task NavigateToTestPage()
    {
        var type = Report.DeviceInfo.Device.Type;
        if (string.IsNullOrEmpty(type)) throw new InvalidDataException();

        BaseTestViewModel viewModel = type switch
        {
            "RP" => new RpTestViewModel(Report, true),
            "DC" => new DcTestViewModel(Report, true),
            "SC" => new ScTestViewModel(Report, true),
            "PVB" => new PvbTestViewModel(Report, true),
            "SVB" => new SvbTestViewModel(Report, true),
            _ => throw new NotImplementedException($"The type '{type}' has not been implemented.")
        };

        var pageName = viewModel.GetType().Name.Replace("ViewModel", "");

        await Shell.Current.GoToAsync(pageName, new Dictionary<string, object>
        {
            { "ViewModel", viewModel }
        });
    }

    protected override async Task OnBack()
    {
        await SaveReport();

        var viewModel = new CustomerInfoViewModel(Report);
        await Shell.Current.GoToAsync("///MainPage/CustomerInfo", new Dictionary<string, object>
        {
            ["ViewModel"] = viewModel
        });
    }

    #endregion
}