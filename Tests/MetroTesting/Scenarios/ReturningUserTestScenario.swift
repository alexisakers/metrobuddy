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

    private static func makeUpdates() -> [BalanceUpdate] {
        [
            .adjustment(timestamp: .test(2021, 2, 15)),
            .swipe(timestamp: .test(2021, 2, 2)),
            .swipe(timestamp: .test(2021, 2, 1)),
            .swipe(timestamp: .test(2021, 1, 30)),
            .swipe(timestamp: .test(2021, 1, 30)),
            .swipe(timestamp: .test(2021, 1, 20)),
            .swipe(timestamp: .test(2021, 1, 20)),
            .swipe(timestamp: .test(2021, 1, 10)),
            .swipe(timestamp: .test(2021, 1, 10)),
        ]
    }

    public static func makeDataStore() -> MetroCardDataStore {
        return MockMetroCardDataStore(
            card: makeCard(),
            balanceUpdates: makeUpdates(),
            createsCardAutomatically: true,
            allowUpdates: true
        )
    }

    public static func makePreferences() -> UserPreferences {
        let userDefaults = MockPreferences()
        userDefaults.setValue(true, forKey: .userDidOnboard)
        return userDefaults
    }
}
