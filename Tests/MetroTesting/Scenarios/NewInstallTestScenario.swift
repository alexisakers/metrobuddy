import Foundation
import MetroKit

/// Reproduces the state of the data when the user first installs the app.
@objc(NewInstallTestScenario)
public final class NewInstallTestScenario: NSObject, TestScenario {
    public static func makeDataStore() -> MetroCardDataStore {
        return MockMetroCardDataStore(
            card: nil,
            createsCardAutomatically: true,
            allowUpdates: true
        )
    }

    public static func makePreferences() -> UserPreferences {
        let userDefaults = MockPreferences()
        userDefaults.setValue(false, forKey: .userDidOnboard)
        return userDefaults
    }
}
