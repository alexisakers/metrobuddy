import Foundation
import MetroKit

/// Test scenarios are classes whose name get  passed into the app's launch arguments, so that it can construct a mock
/// data store in UI tests. You implement the `makeDataStore` to create a data store that matches your test case's inital state.
public protocol TestScenario: NSObjectProtocol {
    /// Called by the `AppDelegate` during UI tests to load a mock data store.
    static func makeDataStore() -> MetroCardDataStore

    /// Called by the `AppDelegate` during UI tests to load mock preferences.
    static func makePreferences() -> UserPreferences
}
