import CoreData
import MetroTesting
import XCTest
@testable import MetroKit

final class MigrationServiceTests: XCTestCase {
    var container: NSPersistentContainer!

    override func setUpWithError() throws {
        try super.setUpWithError()
        container = NSPersistentContainer(
            name: "MigrationServiceTests",
            managedObjectModel: .metroModels
        )

        let inMemoryStore = NSPersistentStoreDescription()
        inMemoryStore.setOption(NSInMemoryStoreType as NSString, forKey: NSStoreTypeKey)
        container.persistentStoreDescriptions = [inMemoryStore]

        try container.loadPersistentStoresAndWait()
    }

    override func tearDown() {
        super.tearDown()
        container = nil
    }

    func testThatItPerformsMigrations() throws {
        // GIVEN
        let userDefaults = UserDefaults(suiteName: #function)!
        userDefaults.setValue(.v1_0_0, forKey: .dataModelVersion)

        let migration = FakeMigration()
        let migrationService = MigrationService(
            migrations: [.v1_1_0: [migration]],
            preferences: userDefaults,
            managedObjectModel: .metroModels
        )

        // WHEN
        try migrationService.run(in: container.viewContext)

        // THEN
        XCTAssertEqual(.v1_1_0, userDefaults.value(forKey: .dataModelVersion))
        XCTAssertEqual(migration.applyCount, 1)
    }

    func testThatItIgnoresMigrationIfVersionsMatch() throws {
        // GIVEN
        let userDefaults = UserDefaults(suiteName: #function)!
        userDefaults.setValue(.v1_1_0, forKey: .dataModelVersion)

        let migration = FakeMigration()
        let migrationService = MigrationService(
            migrations: [.v1_1_0: [migration]],
            preferences: userDefaults,
            managedObjectModel: .metroModels
        )

        // WHEN
        try migrationService.run(in: container.viewContext)

        // THEN
        XCTAssertEqual(.v1_1_0, userDefaults.value(forKey: .dataModelVersion))
        XCTAssertEqual(migration.applyCount, 0)
    }
}

private class FakeMigration: Migration {
    var applyCount = 0
    func apply(in context: NSManagedObjectContext) throws {
        applyCount += 1
    }
}
