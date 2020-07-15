import Foundation
import MetroKit

extension MailComposer.Configuration {
    static func errorReport(appConfiguration: AppConfiguration, message: ErrorMessage) -> MailComposer.Configuration {
        let infoPlist = Bundle.main.infoPlist
        let body = """
        Please enter the steps you took to reach this error here:
        -

        --------
        Diagnostics Information (do not delete)
        App Version: \(infoPlist.version) (\(infoPlist.buildNumber))
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
