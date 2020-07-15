import CoreData

extension NSManagedObjectModel {
    /// Loads the managed object model for Metro Buddy once. This avoids duplication
    /// of the `NSManagedObjectModel` in memory, which messes up entity names.
    static let metroModels: NSManagedObjectModel = {
        let url = Bundle(for: PersistentMetroCardDataStore.self)
            .url(forResource: "MetroModels", withExtension: "momd")!
        
        return NSManagedObjectModel(contentsOf: url)!
    }()
}
