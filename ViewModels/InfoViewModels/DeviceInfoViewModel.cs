using System.ComponentModel;
using System.Windows.Input;
using ABFReportEditor.Util;

namespace ABFReportEditor.ViewModels
{
    // TODO: IMPLEMENT PROTECTION TYPE & SERVICE TYPE FIELDS
    
    public class DeviceInfoViewModel : BaseBackflowViewModel
    {
        // Dropdown Options
        public List<string> InstallationStatusOptions { get; } =
            ["NEW", "EXISTING", "REPLACEMENT"];

        public List<String> ProtectionTypeOptions { get; } =
            ["SECONDARY / CONTAINMENT", "PRIMARY / POINT OF USE"];

        public List<String> ServiceTypeOptions { get; } =
            ["DOMESTIC", "IRRIGATION", "FIRE" ];
        
        public List<string> ManufacturerOptions { get; } =
        [
            "WATTS", "WILKINS", "FEBCO", "AMES", "ARI", "APOLLO",
            "CONBRACO", "HERSEY", "FLOMATIC", "BACKFLOW DIRECT"
        ];

        public List<string> TypeOptions { get; } =
            ["RP", "DC", "PVB", "SVB", "SC", "TYPE 2"];

        // Private fields
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

        // Properties
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

        // Methods
        protected override void LoadFormFields(Dictionary<string, string> formFields)
        {
            WaterPurveyor = formFields.GetValueOrDefault("WaterPurveyor");
            AssemblyAddress = formFields.GetValueOrDefault("AssemblyAddress");
            OnSiteLocation = formFields.GetValueOrDefault("On Site Location of Assembly");
            PrimaryService = formFields.GetValueOrDefault("PrimaryBusinessService");
            InstallationStatus = formFields.GetValueOrDefault("InstallationIs");
            ProtectionType = formFields.GetValueOrDefault("ProtectionType");
            ServiceType = formFields.GetValueOrDefault("ServiceType");
            WaterMeterNo = formFields.GetValueOrDefault("WaterMeterNo");
            SerialNo = formFields.GetValueOrDefault("SerialNo");
            ModelNo = formFields.GetValueOrDefault("ModelNo");
            Size = formFields.GetValueOrDefault("Size");
            Manufacturer = formFields.GetValueOrDefault("Manufacturer");
            Type = formFields.GetValueOrDefault("BFType");
        }

        protected override Task OnNext()
        {
            // TODO: Implement DeviceInfoViewModel.cs OnNext()
            throw new NotImplementedException();
        }
    }
}