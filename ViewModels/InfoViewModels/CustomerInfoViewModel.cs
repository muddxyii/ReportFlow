using ReportFlow.Models.Info;

namespace ReportFlow.ViewModels.InfoViewModels;

public class CustomerInfoViewModel : BaseBackflowViewModel
{
    private CustomerInfo _customerInfo;

    #region Permit Number

    public string? PermitNumber
    {
        get => _customerInfo.PermitNumber;
        set
        {
            _customerInfo.PermitNumber = value;
            OnPropertyChanged(nameof(PermitNumber));
        }
    }

    #endregion

    #region Facility Owner Details

    public string? OwnerName
    {
        get => _customerInfo.OwnerDetails?.Name;
        set
        {
            _customerInfo.OwnerDetails ??= new FacilityOwnerDetails();
            _customerInfo.OwnerDetails.Name = value;

            OnPropertyChanged(nameof(OwnerName));
        }
    }

    public string? OwnerAddress
    {
        get => _customerInfo.OwnerDetails?.Address;
        set
        {
            _customerInfo.OwnerDetails ??= new FacilityOwnerDetails();
            _customerInfo.OwnerDetails.Address = value;
            OnPropertyChanged(nameof(OwnerAddress));
        }
    }

    public string? OwnerContact
    {
        get => _customerInfo.OwnerDetails?.Contact;
        set
        {
            _customerInfo.OwnerDetails ??= new FacilityOwnerDetails();
            _customerInfo.OwnerDetails.Contact = value;
            OnPropertyChanged(nameof(OwnerContact));
        }
    }

    public string? OwnerPhone
    {
        get => _customerInfo.OwnerDetails?.Phone;
        set
        {
            _customerInfo.OwnerDetails ??= new FacilityOwnerDetails();
            _customerInfo.OwnerDetails.Phone = value;
            OnPropertyChanged(nameof(OwnerPhone));
        }
    }

    public string? Email
    {
        get => _customerInfo.OwnerDetails?.Email;
        set
        {
            _customerInfo.OwnerDetails ??= new FacilityOwnerDetails();
            _customerInfo.OwnerDetails.Email = value;
            OnPropertyChanged(nameof(Email));
        }
    }

    #endregion

    #region Representative Details

    public string? RepName
    {
        get => _customerInfo.RepDetails?.Name;
        set
        {
            _customerInfo.RepDetails ??= new RepresentativeDetails();
            _customerInfo.RepDetails.Name = value;
            OnPropertyChanged(nameof(RepName));
        }
    }

    public string? RepAddress
    {
        get => _customerInfo.RepDetails?.Address;
        set
        {
            _customerInfo.RepDetails ??= new RepresentativeDetails();
            _customerInfo.RepDetails.Address = value;
            OnPropertyChanged(nameof(RepAddress));
        }
    }

    public string? RepContact
    {
        get => _customerInfo.RepDetails?.Contact;
        set
        {
            _customerInfo.RepDetails ??= new RepresentativeDetails();
            _customerInfo.RepDetails.Contact = value;
            OnPropertyChanged(nameof(RepContact));
        }
    }

    public string? RepPhone
    {
        get => _customerInfo.RepDetails?.Phone;
        set
        {
            _customerInfo.RepDetails ??= new RepresentativeDetails();
            _customerInfo.RepDetails.Phone = value;
            OnPropertyChanged(nameof(RepPhone));
        }
    }

    #endregion

    #region Constructors

    public CustomerInfoViewModel() : base(new Dictionary<string, string>())
    {
        _customerInfo = new CustomerInfo();
    }

    public CustomerInfoViewModel(Dictionary<string, string> formData) : base(formData)
    {
        _customerInfo = CustomerInfo.FromFormFields(formData);
    }

    #endregion

    #region Navigation Methods

    protected override async Task OnNext()
    {
        // Save form fields to form data
        await SaveFormDataWithCache(_customerInfo.ToFormFields());

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
        await SaveFormDataWithCache(_customerInfo.ToFormFields());

        await Shell.Current.GoToAsync("///MainPage");
    }

    #endregion
}