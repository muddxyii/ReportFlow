using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ABFReportEditor.ViewModels;

namespace ABFReportEditor.Views;

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