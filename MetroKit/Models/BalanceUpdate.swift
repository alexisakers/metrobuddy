import CoreData

/// Represents an update that was applied to the balance of a card.
public struct BalanceUpdate: Hashable, Identifiable {
    public enum UpdateType: Int16 {
        case unknown = 0
        case adjustment = 1
        case reload = 2
        case swipe = 3
    }

    /// The internal identifier of the card.
    public let id: UUID

    /// The type of update.
    public let updateType: UpdateType

    /// The difference in amount to be applied with this update.
    public let amount: Decimal

    /// The time when the balance was updated.
    public let timestamp: Date

    // MARK: - Initialization

    public init(id: UUID, updateType: UpdateType, amount: Decimal, timestamp: Date) {
        self.id = id
        self.updateType = updateType
        self.amount = amount
        self.timestamp = timestamp
    }
}

// MARK: - Core Data

@objc(MBYBalanceUpdate)
final class MBYBalanceUpdate: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var amount: NSDecimalNumber
    @NSManaged var timestamp: Date
    @NSManaged var updateType: Int16
}

extension BalanceUpdate {
    init(managedObject: MBYBalanceUpdate) {
        self.id = managedObject.id
        self.updateType = UpdateType(rawValue: managedObject.updateType) ?? .unknown
        self.timestamp = managedObject.timestamp
        self.amount = managedObject.amount as Decimal
    }
}

extension MBYBalanceUpdate {
    func makeReferenceSnapshot() -> ObjectReference<BalanceUpdate> {
        return ObjectReference(
            objectID: objectID,
            snapshot: BalanceUpdate(managedObject: self)
        )
    }

    func populateFields(with snapshot: BalanceUpdate) {
        id = snapshot.id
        amount = snapshot.amount as NSDecimalNumber
        timestamp = snapshot.timestamp
        updateType = snapshot.updateType.rawValue
    }
}
