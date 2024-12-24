using Android.App;
using Android.Content;
using Android.Content.PM;
using Android.OS;

namespace ReportFlow;

[Activity(Name = "anybackflow.reportflow.activity", Theme = "@style/Maui.SplashTheme", MainLauncher = true,
    LaunchMode = LaunchMode.SingleTask,
    ConfigurationChanges = ConfigChanges.ScreenSize | ConfigChanges.Orientation | ConfigChanges.UiMode |
                           ConfigChanges.ScreenLayout | ConfigChanges.SmallestScreenSize | ConfigChanges.Density)]
public class MainActivity : MauiAppCompatActivity
{
    protected override void OnCreate(Bundle savedInstanceState)
    {
        base.OnCreate(savedInstanceState);
        var configuration = Resources.Configuration;
        configuration.FontScale = 1.0f;
        var metrics = Resources.DisplayMetrics;
        Resources.UpdateConfiguration(configuration, metrics);
    }

    protected override void OnNewIntent(Intent? intent)
    {
        base.OnNewIntent(intent);
        System.Diagnostics.Debug.WriteLine("[MainActivity] OnNewIntent called");

        if (intent?.Data != null)
        {
            System.Diagnostics.Debug.WriteLine("[MainActivity] Intent Data is valid");

            MainThread.BeginInvokeOnMainThread(async () =>
            {
                await Shell.Current.GoToAsync("///MainPage");

                if (Shell.Current?.CurrentPage is MainPage mainPage)
                    mainPage.HandlePdfIntent(new Uri(intent.Data.ToString() ??
                                                     throw new InvalidOperationException()));
            });
        }
    }
}