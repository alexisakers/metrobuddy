import Combine
import CoreData
import MetroKit

/// A concrete data store that can be used to configure in tests. You can configure the card's data, and what operations should fail.
public final class MockMetroCardDataStore: MetroCardDataStore {
    let cardPublisher: CurrentValueSubject<MetroCard?, Never>
    let updatesPublisher: CurrentValueSubject<[BalanceUpdate], Never>
    let id: NSManagedObjectID
    let createsCardAutomatically: Bool
    let allowUpdates: Bool

    // MARK: - Initialization

    /// Creates a new mock data store with the specified options.
    /// - parameter card: The card data to use. Pass `nil` if you want to simulate a fresh install.
    /// - parameter balanceUpdates: The history of balance updatesn for the card. Pass an empty array for a fresh install.
    /// - parameter createsCardAutomatically: Whether we should create the card when first queried. Pass `false` if you want to simulate an
    /// app-unavailable error.
    /// - parameter allowUpdates: Whether updates should succeed. Pass `false` if you want to simulate save failures.
    init(card: MetroCard?, balanceUpdates: [BalanceUpdate], createsCardAutomatically: Bool, allowUpdates: Bool) {
        self.cardPublisher = CurrentValueSubject(card)
        self.updatesPublisher = CurrentValueSubject(balanceUpdates)
        self.id = FakeManagedObjectID()
        self.createsCardAutomatically = createsCardAutomatically
        self.allowUpdates = allowUpdates
    }

    // MARK: - MetroCardDataStore

    public func mergeExternalChanges() {
        // no-op
    }

    public func currentCard() throws -> ObjectReference<MetroCard> {
        if let card = cardPublisher.value {
            return ObjectReference(objectID: id, snapshot: card)
        } else if createsCardAutomatically {
            let card = MetroCard.makeDefault()
            cardPublisher.value = card
            return ObjectReference(objectID: id, snapshot: card)
        } else {
            throw MetroCardDataStoreError.cardNotFound
        }
    }

    public func publisher(for card: ObjectReference<MetroCard>) -> AnyPublisher<ObjectReference<MetroCard>, Never> {
        cardPublisher
            .compactMap {
                $0.map { ObjectReference(objectID: self.id, snapshot: $0) }
            }
            .eraseToAnyPublisher()
    }

    public func balanceUpdatesPublisher(for card: ObjectReference<MetroCard>) -> AnyPublisher<[ObjectReference<BalanceUpdate>], Never> {
        updatesPublisher
            .compactMap {
                $0.map { ObjectReference(objectID: self.id, snapshot: $0) }
            }
            .eraseToAnyPublisher()
    }

    public func applyUpdates(_ updates: [MetroCardUpdate], to cardReference: ObjectReference<MetroCard>) -> AnyPublisher<Void, Error> {
        guard var card = cardPublisher.value else {
            return Fail(error: MetroCardDataStoreError.cardNotFound)
                .eraseToAnyPublisher()
        }

        guard allowUpdates else {
            let error = NSError(domain: NSCocoaErrorDomain, code: NSCoreDataError, userInfo: nil)
            return Fail(error: MetroCardDataStoreError.cannotSave(error))
                .eraseToAnyPublisher()
        }

        for update in updates {
            switch update {
            case .balance(let update):
                card = card.applyingUpdate(update)
                insertBalanceUpdateAndSort(update)
            case .expirationDate(let newDate):
                card = card.withExpirationDate(newDate)
            case .fare(let newFare):
                card = card.withFare(newFare)
            case .serialNumber(let newSerial):
                card = card.withSerialNumber(newSerial)
            }
        }

        cardPublisher.send(card)

        return Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    private func insertBalanceUpdateAndSort(_ update: BalanceUpdate) {
        var updates = updatesPublisher.value
        updates.append(update)
        updates.sort(by: { $0.timestamp < $1.timestamp })
        updatesPublisher.send(updates)
    }
}
