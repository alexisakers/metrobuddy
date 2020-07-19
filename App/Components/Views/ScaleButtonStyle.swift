import SwiftUI

/// A button style that scales down the button on press.
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(.accentColor)
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
    }
}
