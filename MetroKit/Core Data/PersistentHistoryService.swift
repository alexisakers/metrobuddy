import CoreData
import os.log

/// An object that is responsible for detecting and merging external changes using persistent history tracking.
class PersistentHistoryService: NSObject {
    private enum LastTransactionTimestampPreferenceKey: UserPreferenceKey {
        static var name: String = "LastTransactionDate"
        static var defaultValue = Date.distantPast
    }

    let context: NSManagedObjectContext
    let preferences: UserPreferences

    // MARK: - Initialization

    /// Creates a new persistent history service.
    /// - parameter context: The context where external changes should be merged.
    /// - parameter preferences: The preferences where merge timestamps should be stores.
    init(context: NSManagedObjectContext, preferences: UserPreferences) {
        self.context = context
        self.preferences = preferences
        super.init()
    }

    // MARK: - History

    /// Attemps to merge any external changes after the last known merge into the target context.
    func mergeExternalChanges() {
        let lastMerge = preferences.value(forKey: LastTransactionTimestampPreferenceKey.self)
        let fetchHistoryRequest = NSPersistentHistoryChangeRequest.fetchHistory(after: lastMerge)

        do {
            let historyResult = try context.execute(fetchHistoryRequest) as! NSPersistentHistoryResult
            let history = historyResult.result as! [NSPersistentHistoryTransaction]

            let previousStalenessInterval = context.stalenessInterval
            for transaction in history.reversed() {
                context.mergeChanges(fromContextDidSave: transaction.objectIDNotification())
            }
            context.stalenessInterval = previousStalenessInterval

            if let lastTimestamp = history.last?.timestamp {
                let purgeHistoryRequest = NSPersistentHistoryChangeRequest.deleteHistory(before: lastTimestamp)
                try context.execute(purgeHistoryRequest)
                preferences.setValue(lastTimestamp, forKey: LastTransactionTimestampPreferenceKey.self)
            }
        } catch {
            os_log("Cannot merge changes due to error: %@", error as NSError)
        }
    }
}
