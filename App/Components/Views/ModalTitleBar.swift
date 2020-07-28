import SwiftUI

/// A view that contains a title and a close button for a modal.
struct ModalTitleBar: View {
    let title: Text
    @Binding var isPresented: Bool

    var body: some View {
        HStack {
            self.title
                .font(.sheetTitle)
                .minimumScaleFactor(0.1)
                .lineLimit(1)
                .accessibility(addTraits: .isHeader)

            Spacer()
            CloseButton(action: closeButtonTapped)
        }
    }

    private func closeButtonTapped() {
        withAnimation {
            isPresented = false
        }
    }
}
