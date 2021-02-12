import MetroKit
import XCTest

final class MetroCardTests: XCTestCase {
    func testF

    func testRemainingSwipes() {
        // #1: Multiple rides left
        do {
            let card = MetroCard(id: UUID(), balance: 10, expirationDate: nil, serialNumber: nil, fare: 2.75)
            XCTAssertEqual(card.remainingRides, 3)
            XCTAssertEqual(card.formattedRemainingRides, "3 rides left")
        }

        // #2: One ride left (with remainder)
        do {
            let card = MetroCard(id: UUID(), balance: 3, expirationDate: nil, serialNumber: nil, fare: 2.75)
            XCTAssertEqual(card.remainingRides, 1)
            XCTAssertEqual(card.formattedRemainingRides, "1 ride left")
        }

        // #3: One ride left (exact)
        do {
            let card = MetroCard(id: UUID(), balance: 2.75, expirationDate: nil, serialNumber: nil, fare: 2.75)
            XCTAssertEqual(card.remainingRides, 1)
            XCTAssertEqual(card.formattedRemainingRides, "1 ride left")
        }

        // #4: No rides left
        do {
            let card = MetroCard(id: UUID(), balance: 1, expirationDate: nil, serialNumber: nil, fare: 2.75)
            XCTAssertEqual(card.remainingRides, 0)
            XCTAssertEqual(card.formattedRemainingRides, "No rides left")
        }
    }
}
