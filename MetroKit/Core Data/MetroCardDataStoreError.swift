import Foundation

/// A list of errors that can be thrown when interacting with a data store.
public enum MetroCardDataStoreError: LocalizedError {
    /// The specified card reference was not found.
    case cardNotFound

    /// A read operation failed.
    case cannotRead(NSError)
    
    /// A write operation failed.
    case cannotSave(NSError)
    
    // MARK: - LocalizedError
    
    public var errorDescription: String {
        switch self {
        case .cardNotFound:
            return NSLocalizedString(
                "The app's data is out of sync. Please try force-quitting the app and reopening it. If the error persists, please reach out to us with reproduction steps and we will investigate the issue.",
                comment: "An message displayed when the app cannot read the data of what it thinks is the current card."
            )
            
        case .cannotRead(let error):
            let format = NSLocalizedString(
                "Your data could not be loaded, which means it might be corrupted. The error code is %@ %l. Please contact us with reproduction steps and we will investigate the issue. We recommend trying to uninstall and reinstall the app.",
                comment: "A message to inform the user that their data could not be read. The first parameter is the domain code of the error, and the second parameter is the code of the error."
            )
            
            return String(format: format, error.domain, error.code)

        case .cannotSave(let error):
            let format = NSLocalizedString(
                "You changes could not be saved, as an error occured while saving (%@ %l). Please contact us with reproduction steps and we will investigate the issue.",
                comment: "A message to inform the user that their changes were not saved. The first parameter is the domain code of the error, and the second parameter is the code of the error."
            )
            
            return String(format: format, error.domain, error.code)
        }
    }
}
