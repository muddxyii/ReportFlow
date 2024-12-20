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

    protected override bool OnBackButtonPressed()
    {
        if (ViewModel?.BackCommand?.CanExecute(null) == true)
        {
            ViewModel.BackCommand.Execute(null);
            return true;
        }

        return base.OnBackButtonPressed();
    }

    #region Entry Related

    protected void OnEntryNumericChanged(object sender, TextChangedEventArgs e)
    {
        if (sender is not Entry entry) return;

        var newText = e.NewTextValue;

        if (string.IsNullOrWhiteSpace(newText)) return;

        if (string.IsNullOrWhiteSpace(newText) || newText.Contains(" ") ||
            (!decimal.TryParse(newText, out _) && newText != "."))
        {
            var cursorPosition = entry.CursorPosition;
            entry.Text = e.OldTextValue;

            entry.CursorPosition = Math.Max(cursorPosition, 0);
        }
    }

    #endregion

    #region Picker Related

    protected void OnLabelTapped(object sender, TappedEventArgs e)
    {
        if (e.Parameter is Picker picker)
            picker.Focus();
        else if (e.Parameter is DatePicker datePicker) datePicker.Focus();
    }

    #endregion

    #region Checkbox Related

    protected void OnCheckboxLabelTapped(object sender, TappedEventArgs e)
    {
        if (e.Parameter is CheckBox checkbox) checkbox.IsChecked = !checkbox.IsChecked;
    }

    #endregion

    #region Section Related

    protected virtual void OnSectionButtonClicked(object sender, EventArgs e)
    {
        throw new NotImplementedException();
    }

    #endregion
}