import CoreData

/// A migration from v1 to v1.1 that adds a default adjustment balance update for the current balance.
struct BalanceUpdateMigration: Migration {
    func apply(in context: NSManagedObjectContext) throws {
        let fetchRequest = NSFetchRequest<MBYMetroCard>(entityName: "MetroCard")
        fetchRequest.fetchLimit = 1

        guard
            let existingCard = try context.fetch(fetchRequest).first,
            existingCard.balance.compare(0) == .orderedDescending
        else {
            return
        }

        let update = MBYBalanceUpdate(context: context)
        update.id = UUID()
        update.amount = existingCard.balance
        update.timestamp = Date()
        update.updateType = BalanceUpdate.UpdateType.adjustment.rawValue

        existingCard.balanceUpdates
            .insert(update)
    }
}

