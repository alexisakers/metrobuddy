import SwiftUI

/// A button that opens the shortcut list sheet.
struct ShortcutsButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image.Assets.siriButton
        }.buttonStyle(ScaleButtonStyle())
        .accessibilityElement(children: .ignore)
        .accessibility(identifier: "shortcuts-button")
        .accessibility(label: Text("Siri Shortcuts"))
    }
}
