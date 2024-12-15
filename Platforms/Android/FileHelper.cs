using ReportFlow.Interfaces;

namespace ReportFlow;

public class FileHelper : IFileHelper
{
    public string GetPublicStoragePath(string folderName)
    {
        string baseDirectory = Path.Combine(
            Android.OS.Environment.GetExternalStoragePublicDirectory(Android.OS.Environment.DirectoryDocuments).AbsolutePath,
            folderName);

        Directory.CreateDirectory(baseDirectory);
        return baseDirectory;
    }
}