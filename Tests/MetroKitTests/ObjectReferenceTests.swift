import CoreData
import XCTest
@testable import MetroKit

final class ObjectReferenceTests: XCTestCase {
    func testDynamicMemberLookupOfSnapshotMembers() {
        // GIVEN
        let sut = ObjectReference(
            objectID: NSManagedObjectID(),
            snapshot: "Test"
        )
        
        // THEN
        XCTAssertEqual(sut.count, 4)
    }
}
