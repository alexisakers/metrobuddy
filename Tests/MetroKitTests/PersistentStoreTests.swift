import CoreData
import XCTest
@testable import MetroKit

final class PersistentStoreTest: FileBasedTestCase {
    func testThatItCreatesInMemoryStoreDescription() throws {
        // GIVEN
        let sut = PersistentStore.inMemory
        
        // WHEN
        let storeDescription = try sut.makePersistentStoreDescriptor(in: fileManager, name: "TestStore")
    
        // THEN
        XCTAssertEqual(storeDescription.type, NSInMemoryStoreType)
        assertConfiguration(storeDescription)
    }
 
    func testThatItCreatesOnDiskStoreDescription() throws {
        // GIVEN
        let storeURL = testURL.appendingPathComponent("Data")
        let sut = PersistentStore.onDisk(.url(storeURL))
        
        // WHEN
        let storeDescription = try sut.makePersistentStoreDescriptor(in: fileManager, name: "TestStore")
    
        // THEN
        let expectedURL = storeURL.appendingPathComponent("TestStore.sqlite")
        XCTAssertEqual(storeDescription.type, NSSQLiteStoreType)
        XCTAssertEqual(storeDescription.url, expectedURL)
        assertConfiguration(storeDescription)
    }
        
    // MARK: - Helpers
    
    func assertConfiguration(_ storeDescription: NSPersistentStoreDescription, file: StaticString = #file, line: UInt = #line) {
        XCTAssertFalse(storeDescription.shouldAddStoreAsynchronously, file: file, line: line)
        XCTAssertTrue(storeDescription.shouldInferMappingModelAutomatically, file: file, line: line)
        XCTAssertTrue(storeDescription.shouldMigrateStoreAutomatically, file: file, line: line)
    }
}
