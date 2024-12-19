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

    #region Constructor

    public CustomerInfoViewModel() : base(new Dictionary<string, string>())
    {
    }

    public CustomerInfoViewModel(Dictionary<string, string>? formData) : base(formData)
    {
        InitFormFields();
    }

    protected sealed override void InitFormFields()
    {
        PermitNumber = FormData.GetValueOrDefault("PermitAccountNo");
        FacilityOwner = FormData.GetValueOrDefault("FacilityOwner");
        CustomerAddress = FormData.GetValueOrDefault("Address");
        Contact = FormData.GetValueOrDefault("Contact");
        Phone = FormData.GetValueOrDefault("Phone");
        Email = FormData.GetValueOrDefault("Email");
        OwnerRep = FormData.GetValueOrDefault("OwnerRep");
        RepAddress = FormData.GetValueOrDefault("RepAddress");
        PersonToContact = FormData.GetValueOrDefault("PersontoContact");
        ContactPhone = FormData.GetValueOrDefault("Phone-0");
    }

    #endregion

    #region Abstract function implementation

    private Dictionary<string, string> GetFormFields()
    {
        // Save form fields to form data
        Dictionary<string, string> formFields = new()
        {
            { "PermitAccountNo", PermitNumber ?? string.Empty },
            { "FacilityOwner", FacilityOwner ?? string.Empty },
            { "Address", CustomerAddress ?? string.Empty },
            { "Contact", Contact ?? string.Empty },
            { "Phone", Phone ?? string.Empty },
            { "Email", Email ?? string.Empty },
            { "OwnerRep", OwnerRep ?? string.Empty },
            { "RepAddress", RepAddress ?? string.Empty },
            { "PersontoContact", PersonToContact ?? string.Empty },
            { "Phone-0", ContactPhone ?? string.Empty }
        };

        return formFields;
    }

    protected override async Task OnNext()
    {
        // Save form fields to form data
        var formFields = GetFormFields();
        await SaveFormDataWithCache(formFields);

        // Create next view model with FormData
        var viewModel = new DeviceInfoViewModel(FormData);
        await Shell.Current.GoToAsync("DeviceInfo", new Dictionary<string, object>
        {
            ["ViewModel"] = viewModel
        });
    }

    protected override async Task OnBack()
    {
        // Save form fields to form data
        var formFields = GetFormFields();
        await SaveFormDataWithCache(formFields);

        await Shell.Current.GoToAsync("///MainPage");
    }

    #endregion
}