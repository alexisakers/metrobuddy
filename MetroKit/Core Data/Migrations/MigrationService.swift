import CoreData

/// A service that handles performing the necessary migrations while the app launches to ensure a consistent data model.
/// - note: Update `MigrationService.migrations` to add a new migration to the list.
final class MigrationService {
    static var migrations: [ModelVersion: [Migration]] = [
        .v1_0_0: [
            BalanceUpdateMigration()
        ]
    ]

    let preferences: UserPreferences
    let managedObjectModel: NSManagedObjectModel
    init(preferences: UserPreferences, managedObjectModel: NSManagedObjectModel) {
        self.preferences = preferences
        self.managedObjectModel = managedObjectModel
    }

    func run(in managedObjectContent: NSManagedObjectContext) throws {
        let currentVersion = preferences.value(forKey: .dataModelVersion)
        let missedVersions = ModelVersion
            .allCases
            .sorted()
            .drop { $0 <= currentVersion }

        var migrationError: Error?
        managedObjectContent.performAndWait {
            for version in missedVersions {
                do {
                    try Self.migrations[version]?.forEach {
                        try $0.apply(in: managedObjectContent)
                    }
                } catch {
                    migrationError = error
                    break
                }
            }

            do {
                try managedObjectContent.save()
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
