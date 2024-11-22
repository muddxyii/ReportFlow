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

    protected void OnEntryNumericChanged(object sender, TextChangedEventArgs e)
    {
        if (sender is not Entry entry) return;

        string newText = e.NewTextValue;

        if (string.IsNullOrWhiteSpace(newText)) return;

        if (string.IsNullOrWhiteSpace(newText) || newText.Contains(" ") ||
            (!decimal.TryParse(newText, out _) && newText != "."))
        {
            int cursorPosition = entry.CursorPosition;
            entry.Text = e.OldTextValue;

            entry.CursorPosition = Math.Max(cursorPosition, 0);
        }
    }
}