namespace ReportFlow.Interfaces;

/// <summary>
///     Interface that provides file system helper methods for managing storage paths.
/// </summary>
public interface IFileHelper
{
    /// <summary>
    ///     Retrieves the path to a public storage folder for a specified subfolder on the file system.
    ///     This method is typically used to determine the location of platform-specific storage
    ///     for saving files that should be accessible outside the application's private storage space.
    /// </summary>
    /// <param name="folderName">The name of the subfolder for which the public storage path is required.</param>
    /// <returns>The full path to the specified public storage subfolder as a string.</returns>
    string GetPublicStoragePath(string folderName);
}