import SwiftUI
import MessageUI

/// A view that displays a mail composer with a content configuration.
final class MailComposer: UIViewControllerRepresentable {
    struct Configuration: Hashable, Identifiable {
        let recipients: [String]?
        let subject: String?
        let body: String?
        
        var id: Int {
            hashValue
        }
    }

    let configuration: Configuration
    let onDismiss: () -> Void
    
    init(configuration: Configuration, onDismiss: @escaping () -> Void) {
        self.configuration = configuration
        self.onDismiss = onDismiss
    }
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        let onDismiss: () -> Void

        init(onDismiss: @escaping () -> Void) {
            self.onDismiss = onDismiss
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            onDismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(onDismiss: onDismiss)
    }
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let viewController = MFMailComposeViewController()
        viewController.setToRecipients(configuration.recipients)
        
        if let subject = configuration.subject {
            viewController.setSubject(subject)
        }
        
        if let body = configuration.body {
            viewController.setMessageBody(body, isHTML: false)
        }
        
        viewController.mailComposeDelegate = context.coordinator
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {
        uiViewController.mailComposeDelegate = context.coordinator
    }
}

// MARK: - Modifier

extension View {
    /// Displays a mail composer with the specified configuration.
    func mailComposer(configuration: Binding<MailComposer.Configuration?>) -> some View {
        sheet(item: configuration) {
            MailComposer(configuration: $0, onDismiss: { configuration.wrappedValue = nil })
        }
    }
}
