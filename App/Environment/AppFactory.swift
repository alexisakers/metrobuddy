import UIKit
import MetroKit

#if DEBUG
import MetroTesting
#endif

/// A namespace that contains helpers to create the components required to launch the app.
enum AppFactory {
    /// Loads the data store. Returns either a mock data store if we are testing, or the production data store otherwise.
    static func loadDataStores() -> (MetroCardDataStore, UserPreferences) {
        #if DEBUG
        return loadMockStoresIfNeeded()
        #else
        return loadDefaultStores()
        #endif
    }

    #if DEBUG
    private static func loadMockStoresIfNeeded() -> (MetroCardDataStore, UserPreferences) {
        if
            let scenarioName = UserDefaults.standard.string(forKey: TestLaunchKeys.scenarioName),
            let scenario = NSClassFromString(scenarioName) as? TestScenario.Type
        {
            UIView.setAnimationsEnabled(false)
            return (scenario.makeDataStore(), scenario.makePreferences())
        } else {
            return loadDefaultStores()
        }
    }
    #endif

    private static func loadDefaultStores() -> (MetroCardDataStore, UserPreferences) {
        let userDefaults = UserDefaults.sharedSuite
        let dataStore = try! PersistentMetroCardDataStore(
            preferences: userDefaults,
            persistentStore: .sharedContainer,
            useCloudKit: true
        )

        return (dataStore, userDefaults)
    }
}
