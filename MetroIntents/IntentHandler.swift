import Intents
import MetroKit

class IntentHandler: INExtension {
    override func handler(for intent: INIntent) -> Any {
        let dataStore = try! PersistentMetroCardDataStore(
            preferences: UserDefaults.sharedSuite,
            persistentStore: .sharedContainer,
            useCloudKit: true
        )

        if intent is MBYSwipeCardIntent {
            return SwipeMetroCardIntentHandler(dataStore: dataStore)
        } else if intent is MBYCheckBalanceIntent {
            return CheckBalanceIntentHandler(dataStore: dataStore)
        }

        return self
    }
}
