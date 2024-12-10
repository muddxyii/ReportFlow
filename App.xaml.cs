using ABFReportEditor.Interfaces;

namespace ABFReportEditor;

public partial class App : Application
{
    private readonly IFileHandlingService _fileHandlingService;
    
    public App()
    {
        InitializeComponent();

        _fileHandlingService = new FileHandlingService();
        MainPage = new AppShell();
    }

    protected override void OnAppLinkRequestReceived(Uri uri)
    {
        base.OnAppLinkRequestReceived(uri);
        
        if (uri.Scheme.Equals("content", StringComparison.OrdinalIgnoreCase))
        {
            // Handle the content URI
            string filePath = uri.ToString();
            MainThread.BeginInvokeOnMainThread(async () =>
            {
                await _fileHandlingService.HandleFileAsync(filePath);
            });
        }
    }
}