import Foundation

/// A key that contains the information needed to store a value in `UserPreferences`.
public struct UserPreferenceKey<Value: PreferenceRepresentable> {
    /// The name of the key.
    public let name: String
    
    /// The default value to return when the key hasn't been set yet.
    public let defaultValue: Value

    public init(name: String, defaultValue: Value) {
        self.name = name
        self.defaultValue = defaultValue
    }
}

// MARK: - Shared Keys

extension UserPreferenceKey {
    /// A key indicating whether the user finished onboarding.
    public static var userDidOnboard: UserPreferenceKey<Bool> {
        UserPreferenceKey<Bool>(name: "UserDidOnboard", defaultValue: false)
    }
}
