import Foundation
import MetroKit

/// A protocol that contains the necessary infomation to read values from a bundle's info plist.
protocol InfoPlistKey {
    associatedtype Value: PropertyListRepresentable
    /// The name of the `Info.plist` key.
    static var name: String { get }
}

extension Bundle {
    /// Returns the value for the specified info plist key, or `nil` if the value wasn't decoded properly.
    func infoValue<Key: InfoPlistKey>(forKey infoPlistKey: Key.Type) -> Key.Value? {
        return infoDictionary?[infoPlistKey.name] as? Key.Value
    }
}

// MARK: - Keys

/// Returns the app's marketing version name.
enum AppVersionInfoPlistKey: InfoPlistKey {
    typealias Value = String
    static let name = "CFBundleShortVersionString"
}

/// Returns the app's build number.
enum BuildNumberInfoPlistKey: InfoPlistKey {
    typealias Value = String
    static let name = "CFBundleVersion"
}

/// Returns the name of the group to use for Metro Buddy.
enum AppGroupNameInfoPlistKey: InfoPlistKey {
    typealias Value = String
    static let name = "MBYAppGroupName"
}
