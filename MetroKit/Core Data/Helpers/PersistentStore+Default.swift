import Foundation

extension PersistentStore {
    /// Returns a persistent store representation that points to the data in the app's shared container.
    public static var sharedContainer: PersistentStore {
        PersistentStore.onDisk(
            .securityGroupContainer(id: Bundle.sharedContainerID, path: ["Data"])
        )
    }
}

extension Bundle {
    fileprivate static var sharedContainerID: String {
        Bundle(for: PersistentMetroCardDataStore.self)
            .infoDictionary?["MBYAppGroupName"] as! String
    }
}
