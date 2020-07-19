import UIKit
import MetroKit

#if DEBUG
import MetroTesting
#endif

/// A namespace that contains helpers to create the components required to launch the app.
enum AppFactory {
    /// Loads the data store. Returns either a mock data store if we are testing, or the production data store otherwise.
    static func loadDataStore() -> MetroCardDataStore {
        #if DEBUG
        return loadMockStoreIfNeeded()
        #else
        return loadDefaultStore()
        #endif
    }

    private static func loadMockStoreIfNeeded() -> MetroCardDataStore {
        if
            let scenarioName = UserDefaults.standard.string(forKey: MetroTesting.EnvironmentKeys.scenarioName),
            let scenario = NSClassFromString(scenarioName) as? TestScenario.Type
        {
            UIView.setAnimationsEnabled(false)
            return scenario.makeDataStore()
        } else {
            return loadDefaultStore()
        }
    }

    private static func loadDefaultStore() -> MetroCardDataStore {
        let groupID = Bundle.main.infoValue(forKey: AppGroupNameInfoPlistKey.self)!
        return try! PersistentMetroCardDataStore(
            persistentStore: .onDisk(
                .securityGroupContainer(id: groupID, path: ["Data"])
            ),
            useCloudKit: true
        )
    }
}
