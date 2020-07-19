import Combine
import CoreData
@testable import MetroKit

public final class MockMetroCardDataStore: MetroCardDataStore {
    let cardPublisher: CurrentValueSubject<MetroCard?, Never>

    let id: NSManagedObjectID
    var createsCardAutomatically: Bool
    var allowUpdates: Bool

    private var externalChangeObserver: NSObjectProtocol?

    init(card: MetroCard?, createsCardAutomatically: Bool, allowUpdates: Bool) {
        self.cardPublisher = CurrentValueSubject(card)
        self.id = FakeManagedObjectID()
        self.createsCardAutomatically = createsCardAutomatically
        self.allowUpdates = allowUpdates

        externalChangeObserver = NotificationCenter.default
            .addObserver(
                forName: MetroTesting.testDidEmitExternalChangeNotification,
                object: id,
                queue: nil,
                using: { [unowned self] in self.testDidEmitExternalChange($0) }
            )
    }

    // MARK: - MetroCardDataStore

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
        return cardPublisher
            .compactMap {
                $0.map { ObjectReference(objectID: self.id, snapshot: $0) }
            }.eraseToAnyPublisher()
    }

    public func applyUpdates(_ updates: [MetroCardUpdate], to cardReference: ObjectReference<MetroCard>) -> AnyPublisher<Void, Error> {
        guard let card = cardPublisher.value, cardReference.objectID == id else {
            return Fail(error: MetroCardDataStoreError.cardNotFound)
                .eraseToAnyPublisher()
        }

        guard allowUpdates else {
            let error = NSError(domain: NSCocoaErrorDomain, code: NSCoreDataError, userInfo: nil)
            return Fail(error: MetroCardDataStoreError.cannotSave(error))
                .eraseToAnyPublisher()
        }

        performUpdates(updates, on: card)

        return Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    // MARK: - Helpers

    private func testDidEmitExternalChange(_ notifiation: Notification) {
        guard let updates = notifiation.userInfo?[MetroTesting.UserInfoKeys.cardUpdates] as? [MetroCardUpdate] else {
            return
        }

        if let card = cardPublisher.value {
            performUpdates(updates, on: card)
        }
    }

    private func performUpdates(_ updates: [MetroCardUpdate], on card: MetroCard) {
        var card = card
        for update in updates {
            switch update {
            case .balance(let newBalance):
                card = card.withBalance(newBalance)
            case .expirationDate(let newDate):
                card = card.withExpirationDate(newDate)
            case .fare(let newFare):
                card = card.withFare(newFare)
            case .serialNumber(let newSerial):
                card = card.withSerialNumber(newSerial)
            }
        }

        cardPublisher.send(card)
    }
}
