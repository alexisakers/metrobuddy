import Foundation

/// A protocol that indicates that an error's description can be displayed in a UI-friendly way.
public protocol UserFacingError: Error {
    /// A localized description that can be understood a non-tech-savvy user.
    var uiErrorDescription: String { get }    
}
