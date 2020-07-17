import SwiftUI

/// A view that wraps the main context so it can present an alert controller.
fileprivate struct AlertWrapper<Content: View>: UIViewControllerRepresentable {
    final class Coordinator {
        var alertController: ValidatingTextFieldAlertController?
        
        init() {
            self.alertController = nil
        }
    }
    
    let content: Content
    @Binding var alert: TextFieldAlert?
        
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    func makeUIViewController(context: Context) -> UIHostingController<Content> {
        let hostingController = UIHostingController(rootView: content)
        hostingController.overrideUserInterfaceStyle = UIUserInterfaceStyle(context.environment.colorScheme)
        return hostingController
    }
    
    func updateUIViewController(_ uiViewController: UIHostingController<Content>, context: Context) {
        uiViewController.rootView = content
        
        if let alert = alert, uiViewController.presentedViewController == nil {
            let alertController = ValidatingTextFieldAlertController(textFieldAlert: alert, dismiss: dismissAlert)
            alertController.overrideUserInterfaceStyle = UIUserInterfaceStyle(context.environment.colorScheme)
            context.coordinator.alertController = alertController
            uiViewController.present(alertController, animated: true)
        }

        if alert == nil && uiViewController.presentedViewController == context.coordinator.alertController {
            uiViewController.dismiss(animated: true)
        }
    }
    
    private func dismissAlert() {
        alert = nil
    }
}

// MARK: - Helpers

extension View {
    /// Wraps the content inside an alert presenter, to enable to view to show any alert emitted by the binding.
    public func textFieldAlert(item: Binding<TextFieldAlert?>) -> some View {
        return AlertWrapper(content: self, alert: item)
    }
}
