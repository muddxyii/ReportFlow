using System.ComponentModel;
using System.Runtime.CompilerServices;

namespace ReportFlow.ViewModels.ReportViewModels;

public class ReportItemViewModel : INotifyPropertyChanged
{
    private string _reportId = string.Empty;
    private string _serialNumber = string.Empty;
    private string _size = string.Empty;
    private string _customerName = string.Empty;
    private string _location = string.Empty;
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
                OnPropertyChanged();
            }
        }
    }

    public string SerialNumber
    {
        get => _serialNumber;
        set
        {
            if (_serialNumber != value)
            {
                _serialNumber = value;
                OnPropertyChanged();
            }
        }
    }

    public string Size
    {
        get => _size;
        set
        {
            if (_size != value)
            {
                _size = value;
                OnPropertyChanged();
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
                OnPropertyChanged();
            }
        }
    }

    public string Location
    {
        get => _location;
        set
        {
            if (_location != value)
            {
                _location = value;
                OnPropertyChanged();
            }
        }
    }

    public DateTime DateCreated
    {
        get => _dateCreated.ToLocalTime();
        set
        {
            if (_dateCreated != value)
            {
                _dateCreated = value.Kind == DateTimeKind.Unspecified
                    ? DateTime.SpecifyKind(value, DateTimeKind.Utc)
                    : value;
                OnPropertyChanged();
            }
        }
    }

    public DateTime LastModified
    {
        get => _lastModified.ToLocalTime();
        set
        {
            if (_lastModified != value)
            {
                _lastModified = value.Kind == DateTimeKind.Unspecified
                    ? DateTime.SpecifyKind(value, DateTimeKind.Utc)
                    : value;
                OnPropertyChanged();
            }
        }
    }

    protected virtual void OnPropertyChanged([CallerMemberName] string? propertyName = null)
    {
        PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
    }
}