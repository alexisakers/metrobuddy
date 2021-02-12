import Combine
import XCTest
@testable import MetroKit

final class PersistentMetroCardDataStoreTests: XCTestCase {
    var sut: PersistentMetroCardDataStore!
    var cancellables: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
        super.setUp()
        sut = try PersistentMetroCardDataStore(preferences: UserDefaults(suiteName: UUID().uuidString)!, persistentStore: .inMemory, useCloudKit: false)
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        cancellables = []
    }
    
    // MARK: - Get Card
    
    func testThatItReturnsCardWhenItExists() throws {
        // GIVEN
        let snapshot = MetroCard.fake
        let objectID = sut.insert(snapshot: snapshot)
        
        // WHEN
        let card = try sut.currentCard()
        
        // THEN
        XCTAssertEqual(card.objectID, objectID)
        XCTAssertEqual(card.snapshot, snapshot)
    }
    
    func testThatItCreatesCardWhenItDoesntExist() throws {
        // GIVEN
        let card = try sut.currentCard()
        
        // THEN
        assertEqualVisibleData(card.snapshot, MetroCard.makeDefault())
    }
    
    // MARK: - Update Card
    
    func testThatItUpdatesData() throws {
        // GIVEN
        let snapshot = MetroCard.fake
        _ = sut.insert(snapshot: snapshot)
        let card = try sut.currentCard()
        let expirationDate = Date()
        var cards: [ObjectReference<MetroCard>] = []
        
        // WHEN
        let receiveUpdateExpectation = observe(card, receiveValue: {
            cards.append($0)
            return cards.count == 2
        })
        
        receiveUpdateExpectation.assertForOverFulfill = true

        let finishUpdatingCardsExpectation = applyUpdates([
            .balance(BalanceUpdate(id: UUID(), updateType: .adjustment, amount: 22, timestamp: Date())),
            .expirationDate(expirationDate),
            .serialNumber("0987654321"),
            .fare(3)
        ], to: cards[0])
        
        wait(for: [receiveUpdateExpectation, finishUpdatingCardsExpectation], timeout: 5)
        
        // THEN
        XCTAssertEqual(cards.count, 2)
        XCTAssertEqual(cards.last?.snapshot.balance, 22)
        XCTAssertEqual(cards.last?.snapshot.expirationDate, expirationDate)
        XCTAssertEqual(cards.last?.snapshot.serialNumber, "0987654321")
        XCTAssertEqual(cards.last?.snapshot.fare, 3)
    }
    
    func testThatItNotifiesOfUpdates() throws {
        // GIVEN
        let snapshot = MetroCard.fake
        let objectID = sut.insert(snapshot: snapshot)
        let card = try sut.currentCard()
        
        var cards: [ObjectReference<MetroCard>] = []

        // WHEN
        let receiveUpdateExpectation = observe(card, receiveValue: {
                cards.append($0)
                return cards.count == 2
        })

        receiveUpdateExpectation.assertForOverFulfill = true
                
        let finishUpdateExpectation = applyUpdates(
            [
                .balance(BalanceUpdate(id: UUID(), updateType: .adjustment, amount: 22, timestamp: Date())),
            ],
            to: cards[0]
        )
        
        finishUpdateExpectation.expectedFulfillmentCount = 1
        finishUpdateExpectation.assertForOverFulfill = true
        
        wait(for: [receiveUpdateExpectation, finishUpdateExpectation], timeout: 1)
        
        // THEN
        XCTAssertTrue(cards.allSatisfy { $0.objectID == objectID })
        XCTAssertEqual(cards.last?.snapshot.balance, 22)
    }
        
    func testThatItNotifiesOfExternalChanges() throws {
        // GIVEN
        let snapshot = MetroCard.fake
        let objectID = sut.insert(snapshot: snapshot)
        let card = try sut.currentCard()
        
        var cards: [ObjectReference<MetroCard>] = []
        
        // WHEN
        let receiveUpdateExpectation = observe(card, receiveValue: {
                cards.append($0)
                return cards.count == 2
        })

        receiveUpdateExpectation.assertForOverFulfill = true
        
        let context = sut.saveContext
        context.performAndWait {
            let card = context.object(with: objectID) as! MBYMetroCard
            card.balance = 0
            try! context.save()
        }
        
        wait(for: [receiveUpdateExpectation], timeout: 1)
        
        // THEN
        XCTAssertEqual(cards.count, 2)
        XCTAssertEqual(cards.last?.snapshot.balance, 0)
    }

    func testThatItEmitsInitialBalanceUpdates() {
        // GIVEN
        let cardSnapshot = MetroCard.fake
        let balanceUpdate = BalanceUpdate(id: UUID(), updateType: .adjustment, amount: 25, timestamp: Date())

        let cardObjectID = sut.insert(snapshot: cardSnapshot)
        let balanceUpdateObjectID = sut.insert(snapshot: balanceUpdate, forCard: cardObjectID)
        let card = ObjectReference(objectID: cardObjectID, snapshot: cardSnapshot)

        // WHEN
        var updates: [[ObjectReference<BalanceUpdate>]] = []
        let receiveUpdateExpectation = observeBalanceUpdates(for: card, receiveValue: {
            updates.append($0)
            return updates.count == 1
        })

        wait(for: [receiveUpdateExpectation], timeout: 1)

        // THEN
        XCTAssertEqual(updates.count, 1)
        XCTAssertEqual(updates[0], [ObjectReference(objectID: balanceUpdateObjectID, snapshot: balanceUpdate)])
    }

    func testThatItNotifiesOfBalanceUpdates() {
        // GIVEN
        let cardSnapshot = MetroCard.fake
        let balanceUpdate = BalanceUpdate(id: UUID(), updateType: .adjustment, amount: 25, timestamp: Date())

        let cardObjectID = sut.insert(snapshot: cardSnapshot)
        let balanceUpdateObjectID = sut.insert(snapshot: balanceUpdate, forCard: cardObjectID)
        let card = ObjectReference(objectID: cardObjectID, snapshot: cardSnapshot)

        // WHEN
        var updates: [[ObjectReference<BalanceUpdate>]] = []
        let receiveUpdateExpectation = observeBalanceUpdates(for: card, receiveValue: {
            updates.append($0)
            return updates.count == 2
        })

        let update2 = BalanceUpdate(id: UUID(), updateType: .swipe, amount: 2.75, timestamp: Date())
        let update2ObjectID = sut.insert(snapshot: update2, forCard: cardObjectID)

        wait(for: [receiveUpdateExpectation], timeout: 1)

        // THEN
        XCTAssertEqual(updates.count, 2)
        XCTAssertEqual(
            updates,
            [
                [
                    ObjectReference(objectID: balanceUpdateObjectID, snapshot: balanceUpdate)
                ],
                [
                    ObjectReference(objectID: update2ObjectID, snapshot: update2),
                    ObjectReference(objectID: balanceUpdateObjectID, snapshot: balanceUpdate)
                ]
            ]
        )
    }

    func testThatItAppliesCorrectAmounts() {
        // #1: Adjustment
        do {
            let cardSnapshot = MetroCard(id: UUID(), balance: 10, expirationDate: nil, serialNumber: nil, fare: 2.75)
            let cardID = sut.insert(snapshot: cardSnapshot)
            let cardReference = ObjectReference(objectID: cardID, snapshot: cardSnapshot)

            let update = BalanceUpdate(id: UUID(), updateType: .adjustment, amount: 20, timestamp: Date())
            let updateCompleted = expectation(description: "Swipe update completes")

            // WHEN
            var latestCard = cardSnapshot
            let cardUpdates = observe(cardReference) {
                latestCard = $0.snapshot
                return latestCard.balance == 20
            }

            sut.applyUpdates([.balance(update)], to: cardReference)
                .sink(receiveCompletion: { _ in }, receiveValue: updateCompleted.fulfill)
                .store(in: &cancellables)

            // THEN
            wait(for: [updateCompleted, cardUpdates], timeout: 1)
        }

        // #2: Reload
        do {
            let cardSnapshot = MetroCard(id: UUID(), balance: 10, expirationDate: nil, serialNumber: nil, fare: 2.75)
            let cardID = sut.insert(snapshot: cardSnapshot)
            let cardReference = ObjectReference(objectID: cardID, snapshot: cardSnapshot)

            let update = BalanceUpdate(id: UUID(), updateType: .reload, amount: 20, timestamp: Date())
            let updateCompleted = expectation(description: "Swipe update completes")

            // WHEN
            var latestCard = cardSnapshot
            let cardUpdates = observe(cardReference) {
                latestCard = $0.snapshot
                return latestCard.balance == 30
            }

            sut.applyUpdates([.balance(update)], to: cardReference)
                .sink(receiveCompletion: { _ in }, receiveValue: updateCompleted.fulfill)
                .store(in: &cancellables)

            // THEN
            wait(for: [updateCompleted, cardUpdates], timeout: 1)
        }

        // #3: Swipe
        do {
            let cardSnapshot = MetroCard(id: UUID(), balance: 10, expirationDate: nil, serialNumber: nil, fare: 2.75)
            let cardID = sut.insert(snapshot: cardSnapshot)
            let cardReference = ObjectReference(objectID: cardID, snapshot: cardSnapshot)

            let update = BalanceUpdate(id: UUID(), updateType: .swipe, amount: 2, timestamp: Date())
            let updateCompleted = expectation(description: "Swipe update completes")

            // WHEN
            var latestCard = cardSnapshot
            let cardUpdates = observe(cardReference) {
                latestCard = $0.snapshot
                return latestCard.balance == 8
            }

            sut.applyUpdates([.balance(update)], to: cardReference)
                .sink(receiveCompletion: { _ in }, receiveValue: updateCompleted.fulfill)
                .store(in: &cancellables)

            // THEN
            wait(for: [updateCompleted, cardUpdates], timeout: 1)
        }
    }
    
    // MARK: - Helpers
    
    func assertEqualVisibleData(_ lhs: MetroCard, _ rhs: MetroCard, file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertEqual(lhs.balance, rhs.balance, file: file, line: line)
        XCTAssertEqual(lhs.fare, rhs.fare, file: file, line: line)
        XCTAssertEqual(lhs.expirationDate, rhs.expirationDate, file: file, line: line)
        XCTAssertEqual(lhs.serialNumber, rhs.serialNumber, file: file, line: line)
    }
    
    func observe(_ card: ObjectReference<MetroCard>, receiveValue: @escaping (ObjectReference<MetroCard>) -> Bool, file: StaticString = #filePath, line: UInt = #line)  -> XCTestExpectation {
        let receiveUpdateExpectation = expectation(description: "The cards stream sends an update.")
        sut.publisher(for: card)
            .share()
            .sink(
                receiveCompletion: {
                    XCTFail("The card stream completed early: \($0)", file: file, line: line)
                },
                receiveValue: {
                    if receiveValue($0) {
                        print("Received value")
                        receiveUpdateExpectation.fulfill()
                        print(self)
                    }
                }
            ).store(in: &cancellables)
        return receiveUpdateExpectation
    }

    func observeBalanceUpdates(for card: ObjectReference<MetroCard>, receiveValue: @escaping ([ObjectReference<BalanceUpdate>]) -> Bool, file: StaticString = #filePath, line: UInt = #line)  -> XCTestExpectation {
        let receiveUpdateExpectation = expectation(description: "The cards stream sends an update.")
        sut.balanceUpdatesPublisher(for: card)
            .share()
            .sink(
                receiveCompletion: {
                    XCTFail("The card stream completed early: \($0)", file: file, line: line)
                },
                receiveValue: {
                    if receiveValue($0) {
                        print("Received value")
                        receiveUpdateExpectation.fulfill()
                        print(self)
                    }
                }
            ).store(in: &cancellables)
        return receiveUpdateExpectation
    }

    func applyUpdates(_ updates: [MetroCardUpdate], to card: ObjectReference<MetroCard>, file: StaticString = #filePath, line: UInt = #line) -> XCTestExpectation {
        let finishUpdateExpectation = expectation(description: "The update finishes.")
        sut.applyUpdates(updates, to: card)
            .sink(
                receiveCompletion: {
                    if case .failure(let error) = $0 {
                        XCTFail("Unexpected error: \(error)", file: file, line: line)
                    }
            
                    print("Finished update")
                    finishUpdateExpectation.fulfill()
                },
                receiveValue: { _ in }
            )
            .store(in: &cancellables)
        return finishUpdateExpectation
    }
}
