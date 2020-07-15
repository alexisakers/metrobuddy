import SwiftUI
import MessageUI

struct AppConfiguration: Decodable {
    let contactEmail: String
    let buildNumber: String
    
    static let `default`: AppConfiguration = {
        let url = Bundle.main.url(forResource: "App.Configuration", withExtension: "plist")!
        let data = try! Data(contentsOf: url, options: .mappedIfSafe)
        
        return try! PropertyListDecoder()
            .decode(AppConfiguration.self, from: data)
    }()
}

struct InfoPlist {
    let version: String
    let buildNumber: String
}

extension Bundle {
    var infoPlist: InfoPlist {
        return InfoPlist(
            version: infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown",
            buildNumber: infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
        )
    }
}

// MARK: - Environment

struct ConfigurationEnvironmentKey: EnvironmentKey {
    static var defaultValue = AppConfiguration.default
}

struct CanSendMailEnvironmentKey: EnvironmentKey {
    static var defaultValue: Bool = MFMailComposeViewController.canSendMail()
}

extension EnvironmentValues {
    var configuration: AppConfiguration {
        get { self[ConfigurationEnvironmentKey.self] }
        set { self[ConfigurationEnvironmentKey.self] = newValue }
    }
    
    var canSendMail: Bool {
        get { self[CanSendMailEnvironmentKey.self] }
        set { self[CanSendMailEnvironmentKey.self] = newValue }
    }
}
