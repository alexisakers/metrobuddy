import SwiftUI

/// A button to close a modal.
struct CloseButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image.Symbols.closeButton
                .resizable()
                .frame(width: 24, height: 24, alignment: .trailing)
                .padding(8)
        }.accessibility(label: Text("Close"))
        .accessibility(identifier: "close-button")
    }
}
