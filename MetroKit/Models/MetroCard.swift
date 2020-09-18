import CoreData

/// Represents a metro card.
public struct MetroCard: Equatable, Identifiable {
    /// The internal identifier of the card.
    public let id: UUID
    
    /// The balance of the transport card.
    public let balance: Decimal
    
    /// The date when the card expires.
    public let expirationDate: Date?
    
    /// The number at the back of the card.
    public let serialNumber: String?
    
    /// The fare for a single swipe.
    public let fare: Decimal

    // MARK: - Initialization
    
    public init(id: UUID, balance: Decimal, expirationDate: Date?, serialNumber: String?, fare: Decimal) {
        self.id = id
        self.balance = balance
        self.expirationDate = expirationDate
        self.serialNumber = serialNumber
        self.fare = fare
    }

    // MARK: - Helpers

    /// Returns the number of swipes the user can perform with the specified fare.
    public var remainingSwipes: Int {
        guard fare > 0 else { return 0 }
        return balance
            .quotientAndRemainer(dividingBy: fare)
            .quotient
    }
}

// MARK: - Default Card

extension MetroCard {
    public static func makeDefault() -> MetroCard {
        return MetroCard(
            id: UUID(),
            balance: 0,
            expirationDate: nil,
            serialNumber: nil,
            fare: 2.75
        )
    }
}

// MARK: - Core Data

@objc(MBYMetroCard)
final class MBYMetroCard: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var balance: NSDecimalNumber
    @NSManaged var expirationDate: Date?
    @NSManaged var serialNumber: String?
    @NSManaged var fare: NSDecimalNumber
}

extension MetroCard {
    init(managedObject: MBYMetroCard) {
        id = managedObject.id
        balance = managedObject.balance as Decimal
        expirationDate = managedObject.expirationDate
        serialNumber = managedObject.serialNumber
        fare = managedObject.fare as Decimal
    }
}

extension MBYMetroCard {
    func makeReferenceSnapshot() -> ObjectReference<MetroCard> {
        return ObjectReference(
            objectID: objectID,
            snapshot: MetroCard(managedObject: self)
        )
    }
    
    func populateFields(with snapshot: MetroCard) {
        id = snapshot.id
        balance = snapshot.balance as NSDecimalNumber
        expirationDate = snapshot.expirationDate
        serialNumber = snapshot.serialNumber
        fare = snapshot.fare as NSDecimalNumber
    }
}
