using System.ComponentModel;
using System.Runtime.CompilerServices;

namespace ReportFlow.ViewModels.ReportViewModels;

/// Represents the view model for a report item, handling properties related to a report's metadata and supporting property change notifications.
public class ReportItemViewModel : INotifyPropertyChanged
{
    /// <summary>
    /// Stores the unique identifier for a report. This field is used internally
    /// to back the public property <see cref="ReportId"/> and is updated whenever
    /// the corresponding property is modified.
    /// </summary>
    private string _reportId = string.Empty;

    /// <summary>
    /// Stores the name of the customer associated with the report.
    /// </summary>
    /// <remarks>
    /// This private backing field is used in conjunction with the public
    /// property <see cref="CustomerName"/> to provide data binding
    /// and property change notification functionality.
    /// </remarks>
    private string _customerName = string.Empty;

    private string _location = string.Empty;

    /// <summary>
    /// Represents the date and time when the report was created.
    /// </summary>
    private DateTime _dateCreated;

    /// <summary>
    /// Backing field for the public <c>LastModified</c> property.
    /// Represents the timestamp of the last modification for the report item.
    /// The value is stored as a <c>DateTime</c> object with a potential UTC kind specification.
    /// </summary>
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

    public string Location
    {
        get => _location;
        set
        {
            if (_location != value)
            {
                _location = value;
                OnPropertyChanged(nameof(Location));
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
                OnPropertyChanged(nameof(DateCreated));
            }
        }
    }

    /// <summary>
    /// Gets or sets the timestamp indicating the last modification date and time of the report.
    /// </summary>
    /// <remarks>
    /// The value is automatically converted to local time when accessed. When setting the property,
    /// the DateTimeKind is ensured to be UTC if not explicitly specified, and the PropertyChanged event is triggered
    /// if the value changes.
    /// </remarks>
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

    /// <summary>
    /// Raises the PropertyChanged event to notify subscribers that a property value has changed.
    /// </summary>
    /// <param name="propertyName">
    /// The name of the property that has changed. This parameter is optional and will be automatically provided if called from a compiler-generated property.
    /// </param>
    protected virtual void OnPropertyChanged([CallerMemberName] string? propertyName = null)
    {
        PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
    }
}