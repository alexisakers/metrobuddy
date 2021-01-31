import Foundation

enum ModelVersion: String, PreferenceRepresentableEnum {
    case v1_0_0 = "1.0.0"
    case v1_1_0 = "1.1.0"

    static var sortedVersionList: [ModelVersion] {
        return [.v1_0_0, .v1_1_0]
    }
}
