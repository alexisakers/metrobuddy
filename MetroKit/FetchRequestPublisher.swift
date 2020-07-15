import Combine
import CoreData

final class FetchedResultsPublisher<Model: NSManagedObject>: NSObject, Publisher, NSFetchedResultsControllerDelegate {
    typealias Output = [Model]
    typealias Failure = Error
    
    private let resultsController: NSFetchedResultsController<Model>
    private let underlyingSubject = PassthroughSubject<Output, Failure>()
    
    init(context: NSManagedObjectContext, fetchRequest: NSFetchRequest<Model>) throws {
        self.resultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        try resultsController.performFetch()
    }
    
    // MARK: - Publisher
    
    func receive<S: Subscriber>(subscriber: S) where S.Failure == Failure, S.Input == Output {
        underlyingSubject.receive(subscriber: subscriber)
        _ = subscriber.receive(resultsController.fetchedObjects ?? [])
    }
    
    // MARK: - NSFetchedResultsControllerDelegate

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        underlyingSubject.send(resultsController.fetchedObjects ?? [])
    }
}
