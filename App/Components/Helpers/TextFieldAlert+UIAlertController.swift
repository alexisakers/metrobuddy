import UIKit
import ObjectiveC

/// An alert that displays a text field and enables or disables.
class ValidatingTextFieldAlertController: UIAlertController {
    private struct AssociatedKeys {
        static var accessibilityID = "mby_accessibilityID"
    }

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
            $0.accessibilityIdentifier = "alert-text-field"
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

        #if DEBUG
        objc_setAssociatedObject(cancelAction, &AssociatedKeys.accessibilityID, "alert-cancel-button", .OBJC_ASSOCIATION_RETAIN)
        objc_setAssociatedObject(acceptAction, &AssociatedKeys.accessibilityID, "alert-save-button", .OBJC_ASSOCIATION_RETAIN)
        #endif

        addAction(cancelAction)
        addAction(acceptAction)
        preferredAction = acceptAction
        validatedAction = acceptAction
    }

    /// Adds the accessibility IDs to the action views in debug configurations, as it uses a private API.
    func applyAccessibilityIdentifiers() {
        #if DEBUG
        for action in actions {
            guard
                let accessibilityID = objc_getAssociatedObject(action, &AssociatedKeys.accessibilityID) as? String,
                let representer = action.value(forKey: "__representer") as? UIView
            else {
                continue
            }

            representer.accessibilityIdentifier = accessibilityID
        }
        #endif
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Observe changes
        textField?.addTarget(
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
