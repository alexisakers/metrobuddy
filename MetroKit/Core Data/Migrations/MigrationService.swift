import CoreData

/// A service that handles performing the necessary migrations while the app launches to ensure a consistent data model.
/// - note: Update `MigrationService.migrations` to add a new migration to the list.
final class MigrationService {
    static var migrations: [ModelVersion: [Migration]] = [
        .v1_1_0: [
            BalanceUpdateMigration()
        ]
    ]

    let migrations: [ModelVersion: [Migration]]
    let preferences: UserPreferences
    let managedObjectModel: NSManagedObjectModel

    init(
        migrations: [ModelVersion: [Migration]] = MigrationService.migrations,
        preferences: UserPreferences,
        managedObjectModel: NSManagedObjectModel
    ) {
        self.migrations = migrations
        self.preferences = preferences
        self.managedObjectModel = managedObjectModel
    }

    func run(in managedObjectContext: NSManagedObjectContext) throws {
        let currentVersion = preferences.value(forKey: .dataModelVersion)
        let missedVersions = ModelVersion
            .allCases
            .sorted()
            .drop { $0 <= currentVersion }

        var migrationError: Error?
        managedObjectContext.performAndWait {
            for version in missedVersions {
                do {
                    try self.migrations[version]?.forEach {
                        print("Running", type(of: $0))
                        try $0.apply(in: managedObjectContext)
                    }
                } catch {
                    migrationError = error
                    break
                }
            }

            do {
                try managedObjectContext.save()
            } catch {
                migrationError = error
            }
        }

        if let migrationError = migrationError {
            throw migrationError
        }

        let modelVersion = managedObjectModel
            .versionIdentifiers
            .lazy
            .compactMap { $0 as? String }
            .compactMap { ModelVersion(rawValue: $0) }
            .max()

        if let modelVersion = modelVersion {
            preferences.setValue(modelVersion, forKey: .dataModelVersion)
        }
    }
}
