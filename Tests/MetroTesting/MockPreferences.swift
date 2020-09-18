import Foundation
import MetroKit

/// An object that provides temporary, in-memory preferences storage for tests.
public final class MockPreferences: UserPreferences {
    private var storage: [String: Any]
    public init() {
        self.storage = [:]
    }

    public func setValue<Value>(_ value: Value, forKey key: UserPreferenceKey<Value>) where Value : PropertyListRepresentable {
        storage[key.name] = value
    }

    public func value<Value>(forKey key: UserPreferenceKey<Value>) -> Value where Value : PropertyListRepresentable {
        return storage[key.name] as? Value ?? key.defaultValue
    }
}
