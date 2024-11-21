using ABFReportEditor.ViewModels.InfoViewModels;

namespace ABFReportEditor.Views.InfoViews;

[QueryProperty(nameof(ViewModel), "ViewModel")]
public partial class DeviceInfoPage : ContentPage
{
    private DeviceInfoViewModel? _viewModel;

    public DeviceInfoViewModel? ViewModel
    {
        get => _viewModel;
        set
        {
            _viewModel = value;
            BindingContext = _viewModel;
        }
    }
    
    public DeviceInfoPage()
    {
        InitializeComponent();
    }
}