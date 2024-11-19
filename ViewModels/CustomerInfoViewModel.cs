using System.ComponentModel;
using System.Windows.Input;
using ABFReportEditor.Util;

namespace ABFReportEditor.ViewModels
{
    public class CustomerInfoViewModel : BaseBackflowViewModel
    {
        // Private fields
        private string? _permitNumber;
        private string? _facilityOwner;
        private string? _customerAddress;
        private string? _contact;
        private string? _phone;
        private string? _email;
        private string? _ownerRep;
        private string? _repAddress;
        private string? _personToContact;
        private string? _contactPhone;

        // Properties
        public string? PermitNumber
        {
            get => _permitNumber;
            set
            {
                _permitNumber = value;
                OnPropertyChanged(nameof(PermitNumber));
            }
        }

        public string? FacilityOwner
        {
            get => _facilityOwner;
            set
            {
                _facilityOwner = value;
                OnPropertyChanged(nameof(FacilityOwner));
            }
        }

        public string? CustomerAddress
        {
            get => _customerAddress;
            set
            {
                _customerAddress = value;
                OnPropertyChanged(nameof(CustomerAddress));
            }
        }

        public string? Contact
        {
            get => _contact;
            set
            {
                _contact = value;
                OnPropertyChanged(nameof(Contact));
            }
        }

        public string? Phone
        {
            get => _phone;
            set
            {
                _phone = value;
                OnPropertyChanged(nameof(Phone));
            }
        }

        public string? Email
        {
            get => _email;
            set
            {
                _email = value;
                OnPropertyChanged(nameof(Email));
            }
        }

        public string? OwnerRep
        {
            get => _ownerRep;
            set
            {
                _ownerRep = value;
                OnPropertyChanged(nameof(OwnerRep));
            }
        }

        public string? RepAddress
        {
            get => _repAddress;
            set
            {
                _repAddress = value;
                OnPropertyChanged(nameof(RepAddress));
            }
        }

        public string? PersonToContact
        {
            get => _personToContact;
            set
            {
                _personToContact = value;
                OnPropertyChanged(nameof(PersonToContact));
            }
        }

        public string? ContactPhone
        {
            get => _contactPhone;
            set
            {
                _contactPhone = value;
                OnPropertyChanged(nameof(ContactPhone));
            }
        }

        // Methods
        protected override void LoadFormFields(Dictionary<string, string> formFields)
        {
            PermitNumber = formFields.GetValueOrDefault("PermitAccountNo");
            FacilityOwner = formFields.GetValueOrDefault("FacilityOwner");
            CustomerAddress = formFields.GetValueOrDefault("Address");
            Contact = formFields.GetValueOrDefault("Contact");
            Phone = formFields.GetValueOrDefault("Phone");
            Email = formFields.GetValueOrDefault("Email");
            OwnerRep = formFields.GetValueOrDefault("OwnerRep");
            RepAddress = formFields.GetValueOrDefault("RepAddress");
            PersonToContact = formFields.GetValueOrDefault("PersontoContact");
            ContactPhone = formFields.GetValueOrDefault("Phone-0");
        }

        protected override async Task OnNext()
        {
            var viewModel = new DeviceInfoViewModel();
            viewModel.LoadPdfData(PdfData ?? throw new InvalidOperationException());
            await Shell.Current.GoToAsync("DeviceInfo", new Dictionary<string, object>
            {
                ["ViewModel"] = viewModel
            });
        }
    }
}
