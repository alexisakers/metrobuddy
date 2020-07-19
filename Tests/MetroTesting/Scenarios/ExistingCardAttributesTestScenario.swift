import Foundation

@objc(ExistingCardAttributesTestScenario)
public final class ExistingCardAttributesTestScenario: ReturningUserTestScenario {
    override class var serialNumber: String? { "0123456789" }
    override class var expirationDate: Date? { Date(timeIntervalSince1970: 1584676800) }
}
