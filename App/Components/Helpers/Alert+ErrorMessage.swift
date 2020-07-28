import SwiftUI
import MetroKit

extension Alert {
    /// Creates an alert from an error message that allows the user to contact us.
    init(errorMessage: ErrorMessage, configuration: AppConfiguration, emailConfiguration: Binding<MailComposer.Configuration?>) {
        self = Alert(
            title: Text(errorMessage.title),
            message: Text(errorMessage.localizedDescription)
                + Text(verbatim: "\n\n")
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

    /// Creates an alert without a contact button.
    init(errorMessage: ErrorMessage) {
        self = Alert(
            title: Text(errorMessage.title),
            message: Text(errorMessage.localizedDescription),
            dismissButton: .cancel(Text("Close"))
        )
    }
}
