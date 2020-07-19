import MetroKit

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
}
