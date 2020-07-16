import SwiftUI

/// Encapsulates the data to use to configure an alert with a text field.
public struct TextFieldAlert: Identifiable {
    /// The ID of the alert. Make sure each content has its own value, as it is used `Identifiable` conformance.
    public var id: String
    
    /// The title of the alert.
    public var title: String
    
    /// The message of the alert.
    public var message: String
    
    /// The localized text field placeholder.
    public var inputPlaceholder: String
    
    /// The localized title of the accept button.
    public var acceptButtonTitle: String
    
    /// The localized title of the cancel button.
    public var cancelButtonTitle: String
    
    /// An optional block to use to validate the text input and disable the `accept` button.
    public var validator: ((String?) -> Bool)?
    
    /// The block to execute when the alert is cancelled (`nil`) or the text is submitted.
    public var action: (String?) -> ()
    
    /// An optional block to use to configure the text field.
    public var textFieldConfiguration: ((UITextField) -> Void)?
}
