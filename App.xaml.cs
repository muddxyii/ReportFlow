namespace ReportFlow;

public partial class App : Application
{
    public App()
    {
        InitializeComponent();
        MainPage = new AppShell();
    }

    protected override async void OnStart()
    {
        try
        {
            var cacheDir = FileSystem.Current.CacheDirectory;
            var cutoffDate = DateTime.UtcNow.AddDays(-7);

            foreach (var file in Directory.GetFiles(cacheDir, "*.pdf"))
            {
                var fileInfo = new FileInfo(file);
                if (fileInfo.CreationTimeUtc < cutoffDate) File.Delete(file);
            }
        }
        catch (Exception ex)
        {
            // Log error but don't show UI alert since app is starting
            System.Diagnostics.Debug.WriteLine($"PDF cleanup failed: {ex.Message}");
        }
    }
}