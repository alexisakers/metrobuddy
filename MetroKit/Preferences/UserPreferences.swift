import Foundation

/// A protocol for objects that can store the users preferences, keyed by key descriptors conforming to `UserPreferenceKey`.
public protocol UserPreferences {
    /// Gets the value stored in the preferences for the given key, or its default value.
    func value<Key: UserPreferenceKey>(forKey key: Key.Type) -> Key.Value
    
    /// Saves the value for the given key.
    func setValue<Key: UserPreferenceKey>(_ value: Key.Value, forKey key: Key.Type)
}

extension UserDefaults: UserPreferences {
    public func value<Key: UserPreferenceKey>(forKey key: Key.Type) -> Key.Value {
        guard let value = object(forKey: key.name) as? Key.Value else {
            return key.defaultValue
        }
        
        return value
    }
    
    public func setValue<Key: UserPreferenceKey>(_ value: Key.Value, forKey key: Key.Type) {
        setValue(value, forKey: key.name)
    }
}
