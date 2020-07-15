import SwiftUI
import MessageUI


final class MailComposer: UIViewControllerRepresentable {
    struct Configuration {
        let recipients: [String]?
        let subject: String?
        let body: String?
    }

    let configuration: Configuration
    @Binding var isPresented: Bool
    
    init(configuration: Configuration, isPresented: Binding<Bool>) {
        self.configuration = configuration
        self._isPresented = isPresented
    }
    
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        @Binding var isPresented: Bool
        init(isPresented: Binding<Bool>) {
            self._isPresented = isPresented
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            isPresented = false
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(isPresented: $isPresented)
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
