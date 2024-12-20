using ReportFlow.Models;
using ReportFlow.Models.Info;

namespace ReportFlow.ViewModels.InfoViewModels;

public class CustomerInfoViewModel : BaseBackflowViewModel
{
    #region Permit Number

    public string? PermitNumber
    {
        get => Report.CustomerInfo.PermitNumber;
        set
        {
            Report.CustomerInfo.PermitNumber = value;
            OnPropertyChanged(nameof(PermitNumber));
        }
    }

    #endregion

    #region Facility Owner Details

    public string? OwnerName
    {
        get => Report.CustomerInfo.OwnerDetails?.Name;
        set
        {
            Report.CustomerInfo.OwnerDetails ??= new FacilityOwnerDetails();
            Report.CustomerInfo.OwnerDetails.Name = value;

            OnPropertyChanged(nameof(OwnerName));
        }
    }

    public string? OwnerAddress
    {
        get => Report.CustomerInfo.OwnerDetails?.Address;
        set
        {
            Report.CustomerInfo.OwnerDetails ??= new FacilityOwnerDetails();
            Report.CustomerInfo.OwnerDetails.Address = value;
            OnPropertyChanged(nameof(OwnerAddress));
        }
    }

    public string? OwnerContact
    {
        get => Report.CustomerInfo.OwnerDetails?.Contact;
        set
        {
            Report.CustomerInfo.OwnerDetails ??= new FacilityOwnerDetails();
            Report.CustomerInfo.OwnerDetails.Contact = value;
            OnPropertyChanged(nameof(OwnerContact));
        }
    }

    public string? OwnerPhone
    {
        get => Report.CustomerInfo.OwnerDetails?.Phone;
        set
        {
            Report.CustomerInfo.OwnerDetails ??= new FacilityOwnerDetails();
            Report.CustomerInfo.OwnerDetails.Phone = value;
            OnPropertyChanged(nameof(OwnerPhone));
        }
    }

    public string? Email
    {
        get => Report.CustomerInfo.OwnerDetails?.Email;
        set
        {
            Report.CustomerInfo.OwnerDetails ??= new FacilityOwnerDetails();
            Report.CustomerInfo.OwnerDetails.Email = value;
            OnPropertyChanged(nameof(Email));
        }
    }

    #endregion

    #region Representative Details

    public string? RepName
    {
        get => Report.CustomerInfo.RepDetails?.Name;
        set
        {
            Report.CustomerInfo.RepDetails ??= new RepresentativeDetails();
            Report.CustomerInfo.RepDetails.Name = value;
            OnPropertyChanged(nameof(RepName));
        }
    }

    public string? RepAddress
    {
        get => Report.CustomerInfo.RepDetails?.Address;
        set
        {
            Report.CustomerInfo.RepDetails ??= new RepresentativeDetails();
            Report.CustomerInfo.RepDetails.Address = value;
            OnPropertyChanged(nameof(RepAddress));
        }
    }

    public string? RepContact
    {
        get => Report.CustomerInfo.RepDetails?.Contact;
        set
        {
            Report.CustomerInfo.RepDetails ??= new RepresentativeDetails();
            Report.CustomerInfo.RepDetails.Contact = value;
            OnPropertyChanged(nameof(RepContact));
        }
    }

    public string? RepPhone
    {
        get => Report.CustomerInfo.RepDetails?.Phone;
        set
        {
            Report.CustomerInfo.RepDetails ??= new RepresentativeDetails();
            Report.CustomerInfo.RepDetails.Phone = value;
            OnPropertyChanged(nameof(RepPhone));
        }
    }

    #endregion

    #region Constructors

    public CustomerInfoViewModel() : base(new ReportData())
    {
        Report.CustomerInfo = new CustomerInfo();
    }

    public CustomerInfoViewModel(ReportData reportData) : base(reportData)
    {
    }

    #endregion

    #region Navigation Methods

    protected override async Task OnNext()
    {
        await SaveReport();

        // Create next view model with FormData
        var viewModel = new DeviceInfoViewModel(Report);
        await Shell.Current.GoToAsync("DeviceInfo", new Dictionary<string, object>
        {
            ["ViewModel"] = viewModel
        });
    }

    protected override async Task OnBack()
    {
        await SaveReport();

        await Shell.Current.GoToAsync("///MainPage");
    }

    #endregion
}