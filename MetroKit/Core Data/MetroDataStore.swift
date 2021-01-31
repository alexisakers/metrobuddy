import Combine
import CombineExt
import CoreData
import os.log

/// An interface to get and update the user's Metro Card.
public protocol MetroCardDataStore {
    /// Call this method when the `appWillEnterForeground` notification fires to merge potential changes from app extensions that occured while the app
    /// was in the background.
    func mergeExternalChanges()

    /// Returns the user's current Metro Card, or creates one if needed.
    func currentCard() throws -> ObjectReference<MetroCard>
    
    /// A publisher that emits the current card and subsequent updates to it.
    func publisher(for card: ObjectReference<MetroCard>) -> AnyPublisher<ObjectReference<MetroCard>, Never>

    /// A publisher that lists the balance updates for the current card.
    func balanceUpdatesPublisher(for card: ObjectReference<MetroCard>) -> AnyPublisher<[ObjectReference<BalanceUpdate>], Never>

    /// Update the data on the specified card reference by using the given update descriptior.
    func applyUpdates(_ updates: [MetroCardUpdate], to cardReference: ObjectReference<MetroCard>) -> AnyPublisher<Void, Error>
}

/// A concrete Metro card Data store that uses Core Data as a storage mechanism.
public class PersistentMetroCardDataStore: MetroCardDataStore {
    let container: NSPersistentContainer
    let saveContext: NSManagedObjectContext
    let historyService: PersistentHistoryService
    let migrationService: MigrationService

    // MARK: - Initialization
    
    /// Creates a persistent data store using the specified options.
    /// - parameter preferences: The user preferences object used across targets.
    /// - parameter persistentStore: The type of persistent store to use.
    /// - parameter useCloudKit: Whether to use automatic CloudKit syncing.
    /// - throws: Any error thrown while resolving the persistent store. See `PersistentStore` for the possible errors.
    public init(preferences: UserPreferences, persistentStore: PersistentStore, useCloudKit: Bool) throws {
        let managedObjectModel = NSManagedObjectModel.metroModels
        if useCloudKit {
            container = NSPersistentCloudKitContainer(name: "Metro", managedObjectModel: managedObjectModel)
        } else {
            container = NSPersistentContainer(name: "Metro", managedObjectModel: managedObjectModel)
        }
        
        container.persistentStoreDescriptions = [
            try persistentStore.makePersistentStoreDescriptor(in: .default, name: "Metro")
        ]

        try! container.loadPersistentStoresAndWait()
        container.viewContext.automaticallyMergesChangesFromParent = true

        saveContext = container.newBackgroundContext()
        historyService = PersistentHistoryService(context: container.viewContext, preferences: preferences)

        // Run migrations if needed
        migrationService = MigrationService(preferences: preferences, managedObjectModel: managedObjectModel)
        try! migrationService.run(in: container.viewContext)
    }

    // MARK: - History Tracking

    /// Attemps to merge any external changes after the last known merge into the target context. Call this method from `applicationDidFinishLaunching`.
    public func mergeExternalChanges() {
        historyService.mergeExternalChanges()
    }

    // MARK: - Get Card
    
    public func currentCard() throws -> ObjectReference<MetroCard> {
        try getOrCreateCard()
            .map { $0.makeReferenceSnapshot() }
            .get()
    }
    
    public func publisher(for card: ObjectReference<MetroCard>) -> AnyPublisher<ObjectReference<MetroCard>, Never> {
        let card = container.viewContext.object(with: card.objectID) as! MBYMetroCard
        
        return ManagedObjectObserver(context: container.viewContext, object: card)
            .map { $0.makeReferenceSnapshot() }
            .removeDuplicates { $0.snapshot == $1.snapshot }
            .eraseToAnyPublisher()
    }
    
    private func getOrCreateCard() -> Result<MBYMetroCard, MetroCardDataStoreError> {
        let context = container.viewContext
        let fetchRequest = NSFetchRequest<MBYMetroCard>(entityName: "MetroCard")
        fetchRequest.fetchLimit = 1

        do {
            if let existingCard = try context.fetch(fetchRequest).first {
                return .success(existingCard)
            } else {
                return createFirstCard()
            }
        } catch {
            return .failure(.cannotRead(error as NSError))
        }
    }
    
    private func createFirstCard() -> Result<MBYMetroCard, MetroCardDataStoreError> {
        var result: Result<MBYMetroCard, MetroCardDataStoreError>!
        saveContext.performAndWait { [saveContext] in
            do {
                let newCard = MBYMetroCard(context: saveContext)
                newCard.populateFields(with: MetroCard.makeDefault())
                try saveContext.save()

                container.viewContext.performAndWait {
                    let convertedCard = container.viewContext.object(with: newCard.objectID) as! MBYMetroCard
                    result = .success(convertedCard)
                }
            } catch {
                result = .failure(.cannotSave(error as NSError))
            }
        }
        return result
    }

    // MARK: - Get Updates

    public func balanceUpdatesPublisher(for card: ObjectReference<MetroCard>) -> AnyPublisher<[ObjectReference<BalanceUpdate>], Never> {
        let fetchRequest = NSFetchRequest<MBYBalanceUpdate>(entityName: "BalanceUpdate")
        fetchRequest.predicate = NSPredicate(format: "card.id == %@", card.id as NSUUID)
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \MBYBalanceUpdate.timestamp, ascending: false)
        ]

        return FetchedResultsPublisher(fetchRequest: fetchRequest, managedObjectContext: container.viewContext)
            .mapArray { $0.makeReferenceSnapshot() }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    // MARK: - Update Card
    
    public func applyUpdates(_ updates: [MetroCardUpdate], to cardReference: ObjectReference<MetroCard>) -> AnyPublisher<Void, Error> {
        return Future { [saveContext, applyBalanceUpdate] completion in
            saveContext.perform {
                do {
                    guard let card = saveContext.object(with: cardReference.objectID) as? MBYMetroCard else {
                        return completion(.failure(MetroCardDataStoreError.cardNotFound))
                    }

                    for update in updates {
                        switch update {
                        case .balance(let update):
                            applyBalanceUpdate(update, card, saveContext)
                        case .expirationDate(let newValue):
                            card.expirationDate = newValue
                        case .serialNumber(let newValue):
                            card.serialNumber = newValue
                        case .fare(let newValue):
                            card.fare = newValue as NSDecimalNumber
                        }
                    }

                    try saveContext.save()
                    completion(.success(()))
                } catch {
                    completion(.failure(MetroCardDataStoreError.cannotSave(error as NSError)))
                }
            }
        }.eraseToAnyPublisher()
    }

    private func applyBalanceUpdate(_ update: BalanceUpdate, to card: MBYMetroCard, saveContext: NSManagedObjectContext) {
        let updateObject = MBYBalanceUpdate(context: saveContext)
        updateObject.populateFields(with: update)

        card.balanceUpdates.insert(updateObject)

        switch update.updateType {
        case .adjustment:
            card.balance = updateObject.amount
        case .swipe:
            card.balance = card.balance.subtracting(updateObject.amount)
        case .reload:
            card.balance = card.balance.adding(updateObject.amount)
        case .unknown:
            preconditionFailure("Cannot use unknown enum case when requesting an update")
        }
    }
}
