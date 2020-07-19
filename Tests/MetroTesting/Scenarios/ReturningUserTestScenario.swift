import Foundation
import MetroKit

/// Reproduces the state of the data when the user has already used the app. You can override the `class` properties to customize the initial data.
@objc(ReturningUserTestScenario)
public class ReturningUserTestScenario: NSObject, TestScenario {
    class var balance: Decimal { 25 }
    class var expirationDate: Date? { nil }
    class var serialNumber: String? { nil }
    class var fare: Decimal { 2.75 }

    private static func makeCard() -> MetroCard {
        MetroCard(
            id: UUID(),
            balance: balance,
            expirationDate: expirationDate,
            serialNumber: serialNumber,
            fare: fare
        )
    }

    public static func makeDataStore() -> MetroCardDataStore {
        return MockMetroCardDataStore(
            card: makeCard(),
            createsCardAutomatically: true,
            allowUpdates: true
        )
    }

    public static func makePreferences() -> UserPreferences {
        let userDefaults = MockPreferences()
        userDefaults.setValue(true, forKey: UserDidOnboardPreferenceKey.self)
        return userDefaults
    }
}
