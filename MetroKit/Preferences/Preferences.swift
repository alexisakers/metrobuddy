import Foundation


public protocol Preferences {
    func value<Key: UserPreferenceKey>(forKey key: Key.Type) -> Key.Value
    func setValue<Key: UserPreferenceKey>(_ value: Key.Value, forKey key: Key.Type)
}

extension UserDefaults: Preferences {
    public func value<Key: UserPreferenceKey>(forKey key: Key.Type) -> Key.Value {
        guard
            let propertyListValue = object(forKey: key.name) as? Key.Value.PropertyListValue,
            let value = Key.Value(propertyListValue: propertyListValue)
        else {
            return key.defaultValue
        }
        
        return value
    }
    
    public func setValue<Key: UserPreferenceKey>(_ value: Key.Value, forKey key: Key.Type) {
        setValue(value.propertyListValue, forKey: key.name)
    }
}
