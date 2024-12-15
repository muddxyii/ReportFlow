namespace ReportFlow.ViewModels.InfoViewModels;

public class CustomerInfoViewModel : BaseBackflowViewModel
{
    #region Private properties

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

    #endregion

    #region Public properties

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

    #endregion

    #region Abstract function implementation

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
        // Save form fields to form data
        Dictionary<string, string> formFields = new Dictionary<string, string>()
        {
            { "PermitAccountNo", PermitNumber ?? String.Empty },
            { "FacilityOwner", FacilityOwner ?? String.Empty },
            { "Address", CustomerAddress ?? String.Empty },
            { "Contact", Contact ?? String.Empty },
            { "Phone", Phone ?? String.Empty },
            { "Email", Email ?? String.Empty },
            { "OwnerRep", OwnerRep ?? String.Empty },
            { "RepAddress", RepAddress ?? String.Empty },
            { "PersontoContact", PersonToContact ?? String.Empty },
            { "Phone-0", ContactPhone ?? String.Empty }
        };
        SaveFormData(formFields);

        // Create next view model with PdfBytes and FormData
        var viewModel = new DeviceInfoViewModel();
        viewModel.LoadPdfData(PdfData ?? throw new InvalidOperationException(),
            FormData ?? throw new InvalidOperationException());
        await Shell.Current.GoToAsync("DeviceInfo", new Dictionary<string, object>
        {
            ["ViewModel"] = viewModel
        });
    }

    #endregion
}