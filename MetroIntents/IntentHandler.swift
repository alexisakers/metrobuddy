import Intents
import MetroKit

class IntentHandler: INExtension {
    override func handler(for intent: INIntent) -> Any {
        let dataStore = try! PersistentMetroCardDataStore(
            persistentStore: .sharedContainer,
            useCloudKit: true
        )

        if intent is MBYSwipeCardIntent {
            return SwipeMetroCardIntentHandler(dataStore: dataStore)
        }

        return self
    }
}
