using Android.App;
using Android.Content;
using Android.Content.PM;
using Android.OS;

namespace ABFReportEditor;

[Activity(Name="anybackflow.abfreporteditor.activity", Theme = "@style/Maui.SplashTheme", MainLauncher = true, LaunchMode = LaunchMode.SingleTop,
    ConfigurationChanges = ConfigChanges.ScreenSize | ConfigChanges.Orientation | ConfigChanges.UiMode |
                           ConfigChanges.ScreenLayout | ConfigChanges.SmallestScreenSize | ConfigChanges.Density)]
public class MainActivity : MauiAppCompatActivity
{
    protected override void OnNewIntent(Intent? intent)
    {
        base.OnNewIntent(intent);

        if (intent?.Data != null)
        {
            var mainPage = Microsoft.Maui.Controls.Application.Current?.MainPage as MainPage;
            mainPage?.HandlePdfIntent(new Uri(intent.Data.ToString() ?? throw new InvalidOperationException()));
        }
    }
}