import CoreData

/// A list of the different types of persistent stores, that can be converted to a `NSPersistentStoreDescription`.
public enum PersistentStore {
    /// The data will be stored and read in memory, and will be discarded when the process exits.
    case inMemory
    
    /// The data will be stored and read from disk, at the specified location.
    case onDisk(SymbolicLocation)
    
    // MARK: - Helpers
    
    /// Creates a persistent store descriptor to use when initalizing the `NSPersistentContainer`.
    /// - parameter fileManager: The file manager to use to resolve any symbolic location.
    /// - parameter name: The name of the persistent descriptor.
    /// - throws: Any error thrown when resolving symbolic location. See `SymbolicLocation` for possible failures.
    /// - returns: A ready-to-load `NSPersistentStoreDescription`.
    func makePersistentStoreDescriptor(in fileManager: FileManager, name: String) throws -> NSPersistentStoreDescription {
        var storeDescription: NSPersistentStoreDescription
        switch self {
        case .inMemory:
            storeDescription = NSPersistentStoreDescription()
            storeDescription.type = NSInMemoryStoreType
        case .onDisk(let location):
            let url = try fileManager
                .resolve(location)
                .appendingPathComponent(name)
                .appendingPathExtension("sqlite")
            
            storeDescription = NSPersistentStoreDescription(url: url)
            storeDescription.type = NSSQLiteStoreType
            storeDescription.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        }
        
        storeDescription.shouldAddStoreAsynchronously = false
        storeDescription.shouldInferMappingModelAutomatically = true
        storeDescription.shouldMigrateStoreAutomatically = true
        
        return storeDescription
    }
}

