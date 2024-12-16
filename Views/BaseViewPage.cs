using ReportFlow.ViewModels;

namespace ReportFlow.Views;

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

    #region Entry Related
    
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

    #endregion
    
    #region Picker Related
    
    protected void OnLabelTapped(object sender, TappedEventArgs e)
    {
        if (e.Parameter is Picker picker)
        {
            picker.Focus();
        }
        else if (e.Parameter is DatePicker datePicker)
        {
            datePicker.Focus();
        }
    }
    
    #endregion
    
    #region Section Related
    
    protected virtual void OnSectionButtonClicked(object sender, EventArgs e)
    {
        throw new NotImplementedException();
    }
    
    #endregion
}