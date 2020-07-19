import Foundation
import MetroKit

/// An object that provides temporary, in-memory preferences storage for tests.
public final class MockPreferences: UserPreferences {
    private var storage: [String: Any]
    public init() {
        self.storage = [:]
    }

    public func setValue<Key: UserPreferenceKey>(_ value: Key.Value, forKey key: Key.Type) {
        storage[key.name] = value
    }

    public func value<Key: UserPreferenceKey>(forKey key: Key.Type) -> Key.Value {
        return storage[key.name] as? Key.Value ?? Key.defaultValue
    }
}
