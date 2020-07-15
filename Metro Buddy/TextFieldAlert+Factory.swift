import SwiftUI

extension TextAlert {
    static func updateBalance(action: @escaping (String?) -> Void) -> TextAlert {
        TextAlert(
            id: "update-balance",
            title: "Card Balance",
            message: "Enter the current balance on your card.",
            placeholder: "Balance",
            action: action,
            textFieldConfiguration: {
                $0.keyboardType = .decimalPad
            }
        )
    }
    
    static func updateFare(action: @escaping (String?) -> Void) -> TextAlert {
        TextAlert(
            id: "update-fare",
            title: "Current Fare",
            message: "Enter the fare for this card. This may be the current fare, or a discounted fare that applies to your card.",
            placeholder: "Your Fare",
            action: action,
            textFieldConfiguration: {
                $0.keyboardType = .decimalPad
            }
        )
    }
    
    static func updateSerialNumber(action: @escaping (String?) -> Void) -> TextAlert {
        TextAlert(
            id: "update-serial-number",
            title: "Card Number",
            message: "Enter the 10-digit serial number at the back of the card.",
            placeholder: "Card Number",
            action: action,
            textFieldConfiguration: {
                $0.keyboardType = .numberPad
            }
        )
    }
}
