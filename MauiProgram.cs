using ABFReportEditor.Interfaces;
using Microsoft.Extensions.Logging;

namespace ABFReportEditor;

public static class MauiProgram
{
    public static MauiApp CreateMauiApp()
    {
        var builder = MauiApp.CreateBuilder();
        builder
            .UseMauiApp<App>()
            .ConfigureFonts(fonts =>
            {
                fonts.AddFont("OpenSans-Regular.ttf", "OpenSansRegular");
                fonts.AddFont("OpenSans-Semibold.ttf", "OpenSansSemibold");
            });

#if ANDROID
            builder.Services.AddSingleton<IFileHelper, FileHelper>();
            builder.Services.AddTransient<IFileHandlingService, FileHandlingService>();
#endif

#if DEBUG
        builder.Logging.AddDebug();
#endif

        return builder.Build();
    }
}