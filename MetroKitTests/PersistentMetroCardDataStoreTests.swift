import Combine
import XCTest
@testable import MetroKit

final class PersistentMetroCardDataStoreTests: XCTestCase {
    var sut: PersistentMetroCardDataStore!
    var cancellables: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
        super.setUp()
        sut = try PersistentMetroCardDataStore(persistentStore: .inMemory, useCloudKit: false)
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
            .balance(22),
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
                
        let finishUpdateExpectation = applyUpdates([.balance(22)], to: cards[0])
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
