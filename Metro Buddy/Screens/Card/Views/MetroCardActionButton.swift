import SwiftUI

/// A view that displays a label and a button for an action related to a Metro Card.
struct MetroCardActionButton: View {
    enum ActionLabel {
        case add, update
        
        var text: Text {
            switch self {
            case .add:
                return Text("Add")
            case .update:
                return Text("Update")
            }
        }
    }
    
    let title: LocalizedStringKey
    let buttonText: Text
    let action: () -> Void

    // MARK: - Initialization
    
    /// Creates a new action button.
    /// - parameter title: The title that describes the subject of the action.
    /// - parameter value: The localized value that is currently associated with the action.
    /// - parameter actionLabel: The label to use in the action button if there is no value.
    /// - parameter action: The action to execute when the button is pressed.
    init(title: LocalizedStringKey, value: String?, actionLabel: ActionLabel, action: @escaping () -> Void) {
        self.title = title
        self.action = action
        
        if let value = value {
            buttonText = Text(value)
        } else {
            buttonText = actionLabel.text
        }
    }
    
    // MARK: - View
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
            
            RoundedButton(
                title: buttonText,
                titleColor: .white,
                background: Color.black,
                design: .compact,
                action: actionButtonTapped
            )
        }
    }
    
    // MARL: - Input
    
    private func actionButtonTapped() {
        action()
    }
}
