import SwiftUI
import MessageUI

/// Enapsulates the app's static configuration.
struct AppConfiguration: Decodable {
    /// The email at which developers can be contacted.
    let contactEmail: String
    
    /// The default configuration,  as provided by the `App.Configuration.plist` file.
    static let `default`: AppConfiguration = {
        let url = Bundle.main.url(forResource: "App.Configuration", withExtension: "plist")!
        let data = try! Data(contentsOf: url, options: .mappedIfSafe)
        
        return try! PropertyListDecoder()
            .decode(AppConfiguration.self, from: data)
    }()
}

// MARK: - Environment

private struct ConfigurationEnvironmentKey: EnvironmentKey {
    static var defaultValue = AppConfiguration.default
}

private struct CanSendMailEnvironmentKey: EnvironmentKey {
    static var defaultValue: Bool = MFMailComposeViewController.canSendMail()
}

private struct EnableAnimationsEnvironmentKey: EnvironmentKey {
    static var defaultValue: Bool = !ProcessInfo.processInfo.arguments.contains("-DisableAnimations")
}

extension EnvironmentValues {
    /// The app's static configuration.
    var configuration: AppConfiguration {
        get { self[ConfigurationEnvironmentKey.self] }
        set { self[ConfigurationEnvironmentKey.self] = newValue }
    }
    
    /// Whether the user can send e-mails.
    var canSendMail: Bool {
        get { self[CanSendMailEnvironmentKey.self] }
        set { self[CanSendMailEnvironmentKey.self] = newValue }
    }

    /// Whether animations are enabled.
    var enableAnimations: Bool {
        get { self[EnableAnimationsEnvironmentKey.self] }
        set { self[EnableAnimationsEnvironmentKey.self] = newValue }
    }
}
