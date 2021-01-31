import Foundation

/// A protocol for objects that can store the users preferences, keyed by key descriptors conforming to `UserPreferenceKey`.
public protocol UserPreferences {
    /// Gets the value stored in the preferences for the given key, or its default value.
    func value<Value: PreferenceRepresentable>(forKey key: UserPreferenceKey<Value>) -> Value
    
    /// Saves the value for the given key.
    func setValue<Value: PreferenceRepresentable>(_ value: Value, forKey key: UserPreferenceKey<Value>)
}

extension UserDefaults: UserPreferences {
    public func value<Value: PreferenceRepresentable>(forKey key: UserPreferenceKey<Value>) -> Value {
        guard
            let preferenceValue = object(forKey: key.name) as? Value.PreferenceValue,
            let value = Value(preferenceValue: preferenceValue)
        else {
            return key.defaultValue
        }
        
        return value
    }
    
    public func setValue<Value: PreferenceRepresentable>(_ value: Value, forKey key: UserPreferenceKey<Value>) {
        setValue(value.preferenceValue, forKey: key.name)
    }
}
