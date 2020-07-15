import SwiftUI
import UIKit

extension UIAlertController {
    convenience init(alert: TextAlert) {
        self.init(title: alert.title, message: alert.message, preferredStyle: .alert)
        addTextField {
            $0.placeholder = alert.placeholder
            $0.addTarget(self, action: #selector(self.mby_textFieldDidChange), for: [.editingChanged, .editingDidBegin])
            alert.textFieldConfiguration?($0)
        }
        addAction(UIAlertAction(title: alert.cancel, style: .cancel) { _ in
            alert.action(nil)
        })
        let textField = self.textFields?.first
        let acceptAction = UIAlertAction(title: alert.accept, style: .default) { _ in
            alert.action(textField?.text)
        }
        
        addAction(acceptAction)
        preferredAction = acceptAction
    }
    
    @objc private func mby_textFieldDidChange() {
        let textField :UITextField  = textFields![0]
        let addAction: UIAlertAction = actions[1]
        addAction.isEnabled = textField.text?.isEmpty == false
    }
}

struct AlertWrapper<Content: View>: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    let alert: () -> TextAlert?
    let content: Content
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<AlertWrapper>) -> UIHostingController<Content> {
        UIHostingController(rootView: content)
    }
    
    final class Coordinator {
        var alertController: UIAlertController?
        init(_ controller: UIAlertController? = nil) {
            self.alertController = controller
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    
    func updateUIViewController(_ uiViewController: UIHostingController<Content>, context: UIViewControllerRepresentableContext<AlertWrapper>) {
        uiViewController.rootView = content
        if var alert = self.alert(), isPresented, uiViewController.presentedViewController == nil {
            let originalAction = alert.action
            alert.action = {
                self.isPresented = false
                originalAction($0)
            }
            context.coordinator.alertController = UIAlertController(alert: alert)
            uiViewController.present(context.coordinator.alertController!, animated: true)
        }
        if !isPresented && uiViewController.presentedViewController == context.coordinator.alertController {
            uiViewController.dismiss(animated: true)
        }
    }
}

public struct TextAlert: Identifiable {
    public var id: String
    public var title: String
    public var message: String
    public var placeholder: String = ""
    public var accept: String = "OK"
    public var cancel: String = "Cancel"
    public var action: (String?) -> ()
    public var textFieldConfiguration: ((UITextField) -> Void)?
    public var validator: ((String?) -> Bool)?
}

extension View {
    public func textAlert(item: Binding<TextAlert?>) -> some View {
        let isPresented = Binding(
            get: {
                return item.wrappedValue != nil
            },
            set: {
                if $0 == false {
                    item.wrappedValue = nil
                }
            }
        )
        
        return AlertWrapper(isPresented: isPresented, alert: { item.wrappedValue }, content: self)
    }
}
