using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ReportFlow.Views.TestViews;

[QueryProperty(nameof(ViewModel), "ViewModel")]
public partial class PvbTestPage
{
    public PvbTestPage()
    {
        InitializeComponent();
    }
}