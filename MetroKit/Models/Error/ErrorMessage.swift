import Foundation

/// An object that represents the contents of a message to display to the user when an error occurs.
public struct ErrorMessage: Hashable, Identifiable {
    /// The title describing the consequence of the error.
    public let title: String
    
    /// The message describing the reason behind the failure in clear terms.
    public let localizedDescription: String
    
    /// The title of the call to send the developers an email.
    public let contactCTA: String
    
    /// The diagnostic message from the error.
    public let diagnosticMessage: String
    
    public var id: Int {
        hashValue
    }
    
    // MARK: - Initialization
    
    /// Creates an error message with the given title and .
    public init(title: String, error: Error) {
        self.title = title
        self.contactCTA = NSLocalizedString("If the issue persists, please contact us with the steps that lead to the error, and we will investigate. Sorry for the inconvenience.", comment: "")
        self.diagnosticMessage = String(describing: error as NSError)
        
        if let error = error as? UserFacingError {
            self.localizedDescription = error.uiErrorDescription
        } else {
            let format = NSLocalizedString(
                "An unexpected error occured. The error code is %1$@ %2$ld (%3$@).",
                comment: "The first parameter is the error domain. The second parameter is the error code. The third parameter is the error description, that may not be localized/understandable by the user."
            )
            
            let nsError = error as NSError
            self.localizedDescription = .localizedStringWithFormat(format, nsError.domain, nsError.code, nsError.localizedDescription)
        }
    }
}
