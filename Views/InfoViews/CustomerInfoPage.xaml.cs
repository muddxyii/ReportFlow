using ABFReportEditor.ViewModels;

namespace ABFReportEditor.Views;

[QueryProperty(nameof(ViewModel), "ViewModel")]
public partial class CustomerInfoPage : ContentPage
{
    private CustomerInfoViewModel? _viewModel;

    public CustomerInfoViewModel? ViewModel
    {
        get => _viewModel;
        set
        {
            _viewModel = value;
            BindingContext = _viewModel;
        }
    }
    
    public CustomerInfoPage()
    {
        InitializeComponent();
    }
}