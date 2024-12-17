using ReportFlow.Interfaces;
using Microsoft.Extensions.Logging;
using ReportFlow.Services;

namespace ReportFlow;

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
        
        // Add Cache Systems
        builder.Services.AddSingleton<IReportCacheService, ReportCacheService>();

#if ANDROID
            builder.Services.AddSingleton<IFileHelper, FileHelper>();
            builder.Services.AddSingleton<IPdfIntentHelper, PdfIntentHelper>();
#endif

#if DEBUG
        builder.Logging.AddDebug();
#endif

        return builder.Build();
    }
}