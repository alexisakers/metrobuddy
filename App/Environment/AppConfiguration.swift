import SwiftUI
import MessageUI

#if DEBUG
import MetroTesting
#endif

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
        #if DEBUG
        return !UserDefaults.standard.bool(forKey: TestLaunchKeys.disableAnimations) && !accessibilityReduceMotion
        #else
        return !accessibilityReduceMotion
        #endif
    }
}
