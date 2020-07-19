import SwiftUI

/// A button with a rounded background. You can specify whether you want a compact or standard design.
struct RoundedButton<Background: View>: View {
    /// The different designs.
    enum Design {
        /// A standard design to use when the button is on a line alone.
        case standard
        
        /// A compact design to use inside inline contexts.
        case compact
        
        /// The amount of vertical padding to apply.
        var verticalPadding: CGFloat {
            switch self {
            case .standard:
                return 16
            case .compact:
                return 8
            }
        }
    }

    let title: Text
    let titleColor: Color
    let background: Background
    let design: Design
    let action: () -> Void

    // MARK: - Initialization
    
    init(title: Text, titleColor: Color, background: Background, design: Design, action: @escaping () -> Void) {
        self.title = title
        self.titleColor = titleColor
        self.background = background
        self.design = design
        self.action = action
    }
        
    // MARK: - View
    
    var body: some View {
        Button(action: action) {
            title
                .font(.body)
                .fontWeight(.semibold)
                .foregroundColor(titleColor)
                .padding(.horizontal, 2)
                .padding(.vertical, design.verticalPadding)
                .frame(maxWidth: .infinity)
                .background(background)
                .mask(RoundedRectangle.defaultStyle)
                .animation(nil)
        }.buttonStyle(ScaleButtonStyle())
        .accessibilityElement(children: .ignore)
        .accessibility(addTraits: .isButton)
        .accessibility(label: title)
        .frame(maxWidth: .infinity)
    }
}
