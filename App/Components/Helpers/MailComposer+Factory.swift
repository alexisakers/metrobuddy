import Foundation
import MetroKit

extension MailComposer.Configuration {
    static func errorReport(appConfiguration: AppConfiguration, message: ErrorMessage) -> MailComposer.Configuration {
        let version = Bundle.main.infoValue(forKey: AppVersionInfoPlistKey.self) ?? "(null)"
        let buildNumber = Bundle.main.infoValue(forKey: BuildNumberInfoPlistKey.self) ?? "(null)"

        let body = """
        Please enter the steps you took to reach this error here:
        -

        --------
        Diagnostics Information (do not delete)
        App Version: \(version) (\(buildNumber))
        Error: \(message.diagnosticMessage)
        --------
        """
        
        return MailComposer.Configuration(
            recipients: [appConfiguration.contactEmail],
            subject: "Metro Buddy | Error Report",
            body: body
        )
    }
}
