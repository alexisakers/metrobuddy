import Foundation

/// Represents some fields of the bundle's `Info.plist` file.
struct InfoPlist {
    /// The app's version number.
    let version: String
    
    /// The app's build number.
    let buildNumber: String
}

extension Bundle {
    /// Returns the bundle's info plist data.
    var infoPlist: InfoPlist {
        return InfoPlist(
            version: infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown",
            buildNumber: infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
        )
    }
}
