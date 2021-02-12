import CoreData
@testable import MetroKit

extension MetroCard {
    static var fake: MetroCard {
        MetroCard(
            id: UUID(uuidString: "43E94B0C-3C4F-457F-8B95-D6B7CDFAAFB8")!,
            balance: 25.00,
            expirationDate: nil,
            serialNumber: "01234567890",
            fare: 2.75
        )
    }
}

extension PersistentMetroCardDataStore {
    func insert(snapshot: MetroCard) -> NSManagedObjectID {
        var id = NSManagedObjectID()
        let context = saveContext
        context.performAndWait {
            let card = MBYMetroCard(context: context)
            card.populateFields(with: snapshot)
            try! context.save()
            try! context.obtainPermanentIDs(for: [card])
            id = card.objectID
        }
        return id
    }

    func insert(snapshot: BalanceUpdate, forCard cardID: NSManagedObjectID) -> NSManagedObjectID {
        var id = NSManagedObjectID()
        let context = saveContext
        context.performAndWait {
            let update = MBYBalanceUpdate(context: context)
            update.populateFields(with: snapshot)
            update.card = context.object(with: cardID) as? MBYMetroCard

            try! context.save()
            try! context.obtainPermanentIDs(for: [update])
            id = update.objectID
        }
        return id
    }
}
