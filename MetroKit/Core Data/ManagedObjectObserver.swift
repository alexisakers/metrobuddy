import Combine
import CoreData

/// An publisher that notifies subscribers of changes to a specific managed object inside the specified context. When the object
/// is deleted, the publisher completes.
/// - note: The observer makes the following assumptions:
/// - The managed context is the view context.
/// - The object belongs to the view context.
class ManagedObjectObserver<Object: NSManagedObject>: NSObject, Publisher {
    typealias Output = Object
    typealias Failure = Never

    private let underlyingSubject: CurrentValueSubject<Output, Failure>
    private let context: NSManagedObjectContext
    private var notificationToken: NSObjectProtocol?
        
    // MARK: - Lifecycle
        
    /// Creates an observer.
    /// - parameter context: The context on which to observe the changes. Must be a read-only view context.
    /// - parameter object: The object to observe. Must belong to the specified `context`.
    init(context: NSManagedObjectContext, object: Object) {
        assert(context.concurrencyType == .mainQueueConcurrencyType)
        assert(object.managedObjectContext == context)
        
        self.context = context
        self.underlyingSubject = CurrentValueSubject(object)
        super.init()
        
        NotificationCenter.default
            .addObserver(
                self,
                selector: #selector(managedObjectContextObjectsDidChange),
                name: .NSManagedObjectContextObjectsDidChange,
                object: context
            )
    }
    
    // MARK: - Observing
    
    @objc private func managedObjectContextObjectsDidChange(notification: Notification) {
        let changes = notification.managedObjectContextChanges
        let matchesPredicate: (NSManagedObject) -> Bool = {
            $0.objectID == self.underlyingSubject.value.objectID
        }
        
        if let updatedObject = (changes.updated.first(where: matchesPredicate)
            ?? changes.refreshed.first(where: matchesPredicate))
            .flatMap({ $0 as? Object }) {
            underlyingSubject.send(updatedObject)
        } else if changes.deleted.contains(where: matchesPredicate) {
            underlyingSubject.send(completion: .finished)
        }
    }
    
    // MARK: - Publisher
    
    func receive<S: Subscriber>(subscriber: S) where S.Input == Output, S.Failure == Failure {
        // Use the `CurrentValueSubject` as the underlying publisher, sending the current value
        // on subscription and sending the updates.
        underlyingSubject.receive(subscriber: subscriber)
    }
}

// MARK: - Helpers

private struct ManagedObjectContextChanges {
    let updated: Set<NSManagedObject>
    let refreshed: Set<NSManagedObject>
    let inserted: Set<NSManagedObject>
    let deleted: Set<NSManagedObject>
}

extension Notification {
    fileprivate var managedObjectContextChanges: ManagedObjectContextChanges {
        let updated = userInfo?[NSUpdatedObjectsKey] as? Set<NSManagedObject>
        let refreshed = userInfo?[NSRefreshedObjectsKey] as? Set<NSManagedObject>
        let inserted = userInfo?[NSInsertedObjectsKey] as? Set<NSManagedObject>
        let deleted = userInfo?[NSDeletedObjectsKey] as? Set<NSManagedObject>

        return ManagedObjectContextChanges(
            updated: updated ?? [],
            refreshed: refreshed ?? [],
            inserted: inserted ?? [],
            deleted: deleted ?? []
        )
    }
}
