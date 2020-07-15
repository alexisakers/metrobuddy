import Combine
import CoreData

/// An publisher that notifies subscribers of changes to a specific managed object inside the specified context. When the object
/// is deleted, the publisher completes.
/// - note: The observer makes the following assumptions:
/// - The managed context is the view context.
/// - The object will not be modified from the view context.
/// - The object belongs to the view context.
class ManagedObjectContextObserver<Object: NSManagedObject>: NSObject, Publisher {
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
        
        notificationToken = NotificationCenter.default
            .addObserver(
                forName: .NSManagedObjectContextDidMergeChangesObjectIDs,
                object: context,
                queue: .main,
                using: { [unowned self] in
                    self.managedObjectContextObjectsDidChange(notification: $0)
                }
            )
    }
    
    deinit {
        if let token = notificationToken {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    // MARK: - Observing
    
    @objc private func managedObjectContextObjectsDidChange(notification: Notification) {
        let objectID = underlyingSubject.value.objectID
        let changes = notification.managedObjectContextChanges
        
        if changes.updated.contains(objectID) || changes.refreshed.contains(objectID) {
            guard let updatedObject = try? context.existingObject(with: objectID) as? Object else {
                return
            }

            underlyingSubject.send(updatedObject)
        } else if changes.deleted.contains(objectID) {
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
    let updated: Set<NSManagedObjectID>
    let refreshed: Set<NSManagedObjectID>
    let inserted: Set<NSManagedObjectID>
    let deleted: Set<NSManagedObjectID>
}

extension Notification {
    fileprivate var managedObjectContextChanges: ManagedObjectContextChanges {
        let updated = userInfo?[NSUpdatedObjectIDsKey] as? Set<NSManagedObjectID>
        let refreshed = userInfo?[NSRefreshedObjectIDsKey] as? Set<NSManagedObjectID>
        let inserted = userInfo?[NSInsertedObjectIDsKey] as? Set<NSManagedObjectID>
        let deleted = userInfo?[NSDeletedObjectIDsKey] as? Set<NSManagedObjectID>

        return ManagedObjectContextChanges(
            updated: updated ?? [],
            refreshed: refreshed ?? [],
            inserted: inserted ?? [],
            deleted: deleted ?? []
        )
    }
}
