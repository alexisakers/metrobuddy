import UIKit
import ObjectiveC

/// An alert that displays a text field and enables or disables.
class ValidatingTextFieldAlertController: UIAlertController {
    var validator: ((String?) -> Bool)?
    var validatedAction: UIAlertAction?
    
    /// The alerts's main text field.
    var textField: UITextField? {
        return textFields?.first
    }
    
    convenience init(textFieldAlert: TextFieldAlert, dismiss: @escaping () -> Void) {
        self.init(
            title: textFieldAlert.title,
            message: textFieldAlert.message,
            preferredStyle: .alert
        )
        
        self.validator = textFieldAlert.validator
        
        // Configure the text field
        addTextField {
            $0.placeholder = textFieldAlert.inputPlaceholder
            textFieldAlert.textFieldConfiguration?($0)
        }
        
        // Add the actions
        let cancelAction = UIAlertAction(
            title: textFieldAlert.cancelButtonTitle,
            style: .cancel,
            handler: { _ in
                textFieldAlert.action(nil)
                dismiss()
            }
        )
        
        let acceptAction = UIAlertAction(
            title: textFieldAlert.acceptButtonTitle,
            style: .default,
            handler: { _ in
                textFieldAlert.action(self.textField!.text)
                dismiss()
            }
        )
        
        addAction(cancelAction)
        addAction(acceptAction)
        preferredAction = acceptAction
        validatedAction = acceptAction
        
        // Observe changes
        textField!.addTarget(
            self,
            action: #selector(textFieldChanged),
            for: [.editingDidBegin, .editingChanged, .editingDidEnd]
        )
    }
    
    // MARK: - Events
    
    @objc fileprivate func textFieldChanged() {
        guard let validator = validator else {
            return
        }
        
        if validator(textField!.text) == true {
            validatedAction?.isEnabled = true
        } else {
            validatedAction?.isEnabled = false
        }
    }
}
