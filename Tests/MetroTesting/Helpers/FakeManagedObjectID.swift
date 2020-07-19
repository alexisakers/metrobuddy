import CoreData

/// A concrete `NSManagedObjectID` subclass that returns a fake `uriRepresentation`, used in the `MockMetroCardDataStore`.
class FakeManagedObjectID: NSManagedObjectID {
    let uuid = UUID()

    override func isEqual(_ object: Any?) -> Bool {
        guard let otherFakeID = object as? FakeManagedObjectID else {
            return false
        }

        return self.uuid == otherFakeID.uuid
    }

    override func uriRepresentation() -> URL {
        return URL(string: "metro-buddy://tests/objects/\(uuid)")!
    }
}
