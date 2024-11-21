using ABFReportEditor.ViewModels;

namespace ABFReportEditor.Views;

public abstract class BaseViewPage<T> : ContentPage where T : BaseBackflowViewModel
{
    private T? _viewModel;

    public T? ViewModel
    {
        get => _viewModel;
        set
        {
            _viewModel = value;
            BindingContext = _viewModel;
        }
    }
}