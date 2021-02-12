import Combine
import CoreData

/// A publisher that emits new values when the results of a fetched results controller changes.
final class FetchedResultsPublisher<ObjectType: NSManagedObject>: NSObject, NSFetchedResultsControllerDelegate, Publisher {
    typealias Output = [ObjectType]
    typealias Failure = Never

    private let subject = PassthroughSubject<[ObjectType], Never>()
    private let fetchedResultsController: NSFetchedResultsController<ObjectType>

    // MARK: - Initialization
    /// Creates a publisher for the given fetch request and managed object context.
    /// - parameter fetchRequest: The fetch request to observe.
    /// - parameter managedObjectContext: The context to use to run the fetch request.
    init(fetchRequest: NSFetchRequest<ObjectType>, managedObjectContext: NSManagedObjectContext) {
        self.fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        super.init()
        fetchedResultsController.delegate = self

        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Could not perform the initial fetch: \(error)")
        }
    }

    func receive<S: Subscriber>(subscriber: S) where S.Failure == Failure, S.Input == Output {
        let objects = fetchedResultsController.fetchedObjects!
        subject.receive(subscriber: subscriber)
        _ = subscriber.receive(objects)
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        let objects = fetchedResultsController.fetchedObjects!
        subject.send(objects)
    }
}
