import Foundation
import MetroKit

@objc(NewInstallTestScenario)
public final class NewInstallTestScenario: NSObject, TestScenario {
    public static func makeDataStore() -> MetroCardDataStore {
        return MockMetroCardDataStore(
            card: nil,
            createsCardAutomatically: true,
            allowUpdates: true
        )
    }
}
