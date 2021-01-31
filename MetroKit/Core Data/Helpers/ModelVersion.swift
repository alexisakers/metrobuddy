import Foundation

enum ModelVersion: String, CaseIterable, Comparable, PreferenceRepresentableEnum {
    case v1_0_0 = "1.0.0"
    case v1_1_0 = "1.1.0"

    static func < (lhs: ModelVersion, rhs: ModelVersion) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

extension UserPreferenceKey {
    static var dataModelVersion: UserPreferenceKey<ModelVersion> {
        UserPreferenceKey<ModelVersion>(name: "DataModelVersion", defaultValue: .v1_1_0)
    }
}
