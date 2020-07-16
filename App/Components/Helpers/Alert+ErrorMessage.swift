import SwiftUI
import MetroKit

extension Alert {
    /// Creates an alert from an error message.
    init(errorMessage: ErrorMessage, configuration: AppConfiguration, emailConfiguration: Binding<MailComposer.Configuration?>) {
        self = Alert(
            title: Text(errorMessage.title),
            message: Text(errorMessage.localizedDescription)
                + Text(verbatim: "\n")
                + Text(errorMessage.contactCTA),
            primaryButton: .default(
                Text("Contact Us"),
                action: {
                    emailConfiguration.wrappedValue = .errorReport(
                        appConfiguration: configuration,
                        message: errorMessage
                    )
                }
            ),
            secondaryButton: .cancel(Text("Close"))
        )
    }
}
