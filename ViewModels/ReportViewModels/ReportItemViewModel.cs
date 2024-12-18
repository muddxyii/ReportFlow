using System.ComponentModel;
using System.Runtime.CompilerServices;

namespace ReportFlow.ViewModels.ReportViewModels;

public class ReportItemViewModel : INotifyPropertyChanged
{
    private string _reportId = string.Empty;
    private string _customerName = string.Empty;
    private string _address = string.Empty;
    private DateTime _dateCreated;
    private DateTime _lastModified;

    public event PropertyChangedEventHandler? PropertyChanged;

    public string ReportId
    {
        get => _reportId;
        set
        {
            if (_reportId != value)
            {
                _reportId = value;
                OnPropertyChanged(nameof(ReportId));
            }
        }
    }

    public string CustomerName
    {
        get => _customerName;
        set
        {
            if (_customerName != value)
            {
                _customerName = value;
                OnPropertyChanged(nameof(CustomerName));
            }
        }
    }

    public string Address
    {
        get => _address;
        set
        {
            if (_address != value)
            {
                _address = value;
                OnPropertyChanged(nameof(Address));
            }
        }
    }

    public DateTime DateCreated
    {
        get => _dateCreated;
        set
        {
            if (_dateCreated != value)
            {
                _dateCreated = value;
                OnPropertyChanged(nameof(DateCreated));
            }
        }
    }
    
    public DateTime LastModified
    {
        get => _lastModified;
        set
        {
            if (_lastModified != value)
            {
                _lastModified = value;
                OnPropertyChanged();
            }
        }
    }

    protected virtual void OnPropertyChanged([CallerMemberName] string? propertyName = null)
    {
        PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
    }
}