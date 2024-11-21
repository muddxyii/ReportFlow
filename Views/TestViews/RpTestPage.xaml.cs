using ABFReportEditor.ViewModels.TestViewModels;

namespace ABFReportEditor.Views.TestViews;

[QueryProperty(nameof(ViewModel), "ViewModel")]
public partial class RpTestPage : ContentPage
{
    private RpTestViewModel? _viewModel;

    public RpTestViewModel? ViewModel
    {
        get => _viewModel;
        set
        {
            _viewModel = value;
            BindingContext = _viewModel;
        }
    }
    
    public RpTestPage()
    {
        InitializeComponent();
    }
}