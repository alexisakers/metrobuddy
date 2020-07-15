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
    
    func testThatItReturnsCardWhenItExists() {
        // GIVEN
        let snapshot = MetroCard.fake
        let objectID = sut.insert(snapshot: snapshot)
        
        // WHEN
        let card = sut.card()
        let recorder = Recorder(source: card)
        
        // THEN
        XCTAssertNil(recorder.completion)
        XCTAssertEqual(recorder.recordedElements.count, 1)
        XCTAssertEqual(recorder.recordedElements.last?.objectID, objectID)
        XCTAssertEqual(recorder.recordedElements.last?.target, snapshot)
    }
    
    func testThatItCreatesCardWhenItDoesntExist() {
        // GIVEN
        let card = sut.card()
        let recorder = Recorder(source: card)
        
        // THEN
        XCTAssertNil(recorder.completion)
        XCTAssertEqual(recorder.recordedElements.count, 1)
        assertEqualVisibleData(recorder.recordedElements[0].target, MetroCard.makeDefault())
    }
    
    // MARK: - Update Card
    
    func testThatItUpdatesData() {
        // GIVEN
        let snapshot = MetroCard.fake
        _ = sut.insert(snapshot: snapshot)
        let cardsRecorder = Recorder(source: sut.card())
        let expirationDate = Date()
        var cards: [ObjectReference<MetroCard>] = []
        
        // WHEN
        let receiveUpdateExpectation = observeCards(receiveValue: { cards.append($0); return cards.count == 2 })
        receiveUpdateExpectation.assertForOverFulfill = true

        let finishUpdatingCardsExpectation = applyUpdates([
            .balance(22),
            .expirationDate(expirationDate),
            .serialNumber("0987654321"),
            .swipeCost(3)
        ], to: cards[0])
        
        wait(for: [receiveUpdateExpectation, finishUpdatingCardsExpectation], timeout: 1)
        
        // THEN
        XCTAssertEqual(cardsRecorder.recordedElementsCount, 2)
        XCTAssertEqual(cardsRecorder.recordedElements.last?.target.balance, 22)
        XCTAssertEqual(cardsRecorder.recordedElements.last?.target.expirationDate, expirationDate)
        XCTAssertEqual(cardsRecorder.recordedElements.last?.target.serialNumber, "0987654321")
        XCTAssertEqual(cardsRecorder.recordedElements.last?.target.swipeCost, 3)
    }
    
    func testThatItNotifiesOfUpdates() {
        // GIVEN
        let snapshot = MetroCard.fake
        let objectID = sut.insert(snapshot: snapshot)
        var cards: [ObjectReference<MetroCard>] = []

        // WHEN
        let receiveUpdateExpectation = observeCards(receiveValue: { cards.append($0); return cards.count == 2 })
        receiveUpdateExpectation.assertForOverFulfill = true
                
        let finishUpdateExpectation = applyUpdates([.balance(22)], to: cards[0])
        finishUpdateExpectation.expectedFulfillmentCount = 1
        finishUpdateExpectation.assertForOverFulfill = true
        
        wait(for: [receiveUpdateExpectation, finishUpdateExpectation], timeout: 1)
        
        // THEN
        XCTAssertTrue(cards.allSatisfy { $0.objectID == objectID })
        XCTAssertEqual(cards[1].target.balance, 22)
    }
        
    func testThatItNotifiesOfExternalChanges() {
        // GIVEN
        let snapshot = MetroCard.fake
        let objectID = sut.insert(snapshot: snapshot)
        var cards: [ObjectReference<MetroCard>] = []
        
        // WHEN
        let receiveUpdateExpectation = observeCards(receiveValue: { cards.append($0); return cards.count == 2 })
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
        XCTAssertEqual(cards.last?.target.balance, 0)
    }
    
    // MARK: - Helpers
    
    func assertEqualVisibleData(_ lhs: MetroCard, _ rhs: MetroCard, file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertEqual(lhs.balance, rhs.balance, file: file, line: line)
        XCTAssertEqual(lhs.swipeCost, rhs.swipeCost, file: file, line: line)
        XCTAssertEqual(lhs.expirationDate, rhs.expirationDate, file: file, line: line)
        XCTAssertEqual(lhs.serialNumber, rhs.serialNumber, file: file, line: line)
    }
    
    func observeCards(receiveValue: @escaping (ObjectReference<MetroCard>) -> Bool, file: StaticString = #filePath, line: UInt = #line)  -> XCTestExpectation {
        let receiveUpdateExpectation = expectation(description: "The cards stream sends an update.")
        sut.card()
            .handleEvents(receiveCancel: {
                print("Cancel")
            })
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [self] in
                    if receiveValue($0) {
                        receiveUpdateExpectation.fulfill()
                    }
                    print(self.hash)
                }
            )
            .store(in: &cancellables)
        return receiveUpdateExpectation
    }
    
    func applyUpdates(_ updates: [MetroCardUpdate], to card: ObjectReference<MetroCard>, file: StaticString = #filePath, line: UInt = #line) -> XCTestExpectation {
        let finishUpdateExpectation = expectation(description: "The update finishes.")
        sut.applyUpdates(updates, to: card)
            .sink(
                receiveCompletion: { [self]
                    if case .failure(let error) = $0 {
                        XCTFail("Unexpected error: \(error)", file: file, line: line)
                    }
            
                    print(self.hash)
                    finishUpdateExpectation.fulfill()
                },
                receiveValue: { _ in }
            ).store(in: &cancellables)
        return finishUpdateExpectation
    }
}
