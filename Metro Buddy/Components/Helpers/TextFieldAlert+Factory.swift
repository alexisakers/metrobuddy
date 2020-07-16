import SwiftUI

extension TextFieldAlert {
    private static var acceptButtonTitle: String {
        return NSLocalizedString("Save", comment: "")
    }

    private static var cancelButtonTitle: String {
        return NSLocalizedString("Cancel", comment: "")
    }
        
    static func updateBalance(action: @escaping (String?) -> Void) -> TextFieldAlert {
        TextFieldAlert(
            id: "update-balance",
            title: NSLocalizedString("Card Balance", comment: ""),
            message: NSLocalizedString("Enter the current balance on your card.", comment: ""),
            inputPlaceholder: NSLocalizedString("Current Balance", comment: ""),
            acceptButtonTitle: acceptButtonTitle,
            cancelButtonTitle: cancelButtonTitle,
            action: action,
            textFieldConfiguration: {
                $0.keyboardType = .decimalPad
            }
        )
    }
    
    static func updateFare(validator: ((String?) -> Bool)?, action: @escaping (String?) -> Void) -> TextFieldAlert {
        TextFieldAlert(
            id: "update-fare",
            title: NSLocalizedString("Current Fare", comment: ""),
            message: NSLocalizedString("Enter the fare for this card. This may be the current fare, or a discounted fare that applies to your card.", comment: ""),
            inputPlaceholder: NSLocalizedString("Your Fare", comment: ""),
            acceptButtonTitle: acceptButtonTitle,
            cancelButtonTitle: cancelButtonTitle,
            validator: validator,
            action: action,
            textFieldConfiguration: {
                $0.keyboardType = .decimalPad
            }
        )
    }
    
    static func updateSerialNumber(action: @escaping (String?) -> Void) -> TextFieldAlert {
        TextFieldAlert(
            id: "update-serial-number",
            title: NSLocalizedString("Card Number", comment: ""),
            message: NSLocalizedString("Enter the 10-digit serial number at the back of the card.", comment: ""),
            inputPlaceholder: NSLocalizedString("Card Number", comment: ""),
            acceptButtonTitle: acceptButtonTitle,
            cancelButtonTitle: cancelButtonTitle,
            action: action,
            textFieldConfiguration: {
                $0.keyboardType = .numberPad
            }
        )
    }
}
