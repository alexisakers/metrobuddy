import Foundation

/// A key that contains the information needed to store a value in `UserPreferences`.
public protocol UserPreferenceKey {
    /// The type of the value that this key stores. Must be a plist type.
    associatedtype Value: PropertyListRepresentable
    
    /// The name of the key.
    static var name: String { get }
    
    /// The default value to return when the key hasn't been set yet.
    static var defaultValue: Value { get }
}

public enum UserDidOnboardPreferenceKey: UserPreferenceKey {
    public static let name: String = "UserDidOnboard"
    public static let defaultValue: Bool = false
}
