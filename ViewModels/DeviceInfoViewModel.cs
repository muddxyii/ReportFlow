using System.ComponentModel;
using System.Windows.Input;
using ABFReportEditor.Util;

namespace ABFReportEditor.ViewModels
{
    public class DeviceInfoViewModel : BaseBackflowViewModel
    {
        // Private fields
        private string? _waterPuveyor;
        private string? _assemblyAddress;
        private string? _onSiteLocation;
        private string? _primaryService;
        private string? _installationStatus;
        private string? _waterMeterNo;
        private string? _serialNo;
        private string? _modelNo;
        private string? _size;
        private string? _manufacturer;
        private string? _type;

        // Properties
        public string? WaterPurveyor
        {
            get => _waterPuveyor;
            set
            {
                _waterPuveyor = value;
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
        }


        protected override Task OnNext()
        {
            // TODO: Implement DeviceInfoViewModel.cs OnNext()
            throw new NotImplementedException();
        }
    }
}