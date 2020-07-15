import SwiftUI

struct CardDetailsButton: View {
    enum ActionLabel {
        case add, update
        
        var localizationKey: LocalizedStringKey {
            switch self {
            case .add:
                return "Add"
            case .update:
                return "Update"
            }
        }
    }
    
    let title: LocalizedStringKey
    let buttonText: Text
    let action: () -> Void
    
    init(title: LocalizedStringKey, value: String?, actionLabel: ActionLabel, action: @escaping () -> Void) {
        self.title = title
        self.action = action
        
        if let value = value {
            buttonText = Text(value)
        } else {
            buttonText = Text(actionLabel.localizationKey)
        }
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
            
            RoundedButton(
                title: buttonText,
                titleColor: .white,
                background: Color.black,
                padding: .compact,
                action: actionButtonTapped
            )
        }
    }
    
    func actionButtonTapped() {
        withAnimation {
            action()
        }
    }
}
