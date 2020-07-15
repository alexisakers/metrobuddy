import Foundation

/// A list of errors that can be thrown when interacting with a data store.
public enum MetroCardDataStoreError: UserFacingError {
    /// The specified card reference was not found.
    case cardNotFound

    /// A read operation failed.
    case cannotRead(NSError)
    
    /// A write operation failed.
    case cannotSave(NSError)
    
    // MARK: - LocalizedError
    
    public var uiErrorDescription: String {
        switch self {
        case .cardNotFound:
            return NSLocalizedString(
                "The app's data is out of sync. We suggest trying to force-quit the app and reopening it.",
                comment: "A message displayed when the app cannot read the data of what it thinks is the current card."
            )
            
        case .cannotRead(let error):
            let format = NSLocalizedString(
                "Your data could not be loaded, which means it might be corrupted. The error code is %@ %l. We suggest trying to uninstall and reinstall the app.",
                comment: "A message to inform the user that their data could not be read. The first parameter is the domain code of the error, and the second parameter is the code of the error."
            )
            
            return String(format: format, error.domain, error.code)

        case .cannotSave(let error):
            let format = NSLocalizedString(
                "You changes could not be saved, as an error occured while saving. The error code is %@ %l. We suggest trying to force-quit the app and reopening it.",
                comment: "A message to inform the user that their changes were not saved. The first parameter is the domain code of the error, and the second parameter is the code of the error."
            )
            
            return String(format: format, error.domain, error.code)
        }
    }
}
