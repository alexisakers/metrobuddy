import CoreData

extension NSPersistentContainer {
    /// Loads the persistent stores and waits until the completion handler is called.
    /// - throws: Any error that occurs while loading the persistent stores.
    /// - note: This assumes that `shouldAddStoreAsynchronously` is set to `false`
    /// on all the persistent store descriptions, which is the default value.
    func loadPersistentStoresAndWait() throws {
        var error: Error?
        loadPersistentStores { _, completionError in
            error = completionError
        }
        
        if let error = error {
            throw error
        }
    }
}
