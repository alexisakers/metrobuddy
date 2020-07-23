import SwiftUI

struct SheetNavigationBar: View {
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

            Button(action: closeButtonTapped) {
                Image.Symbols.closeButton
                    .resizable()
                    .frame(width: 24, height: 24, alignment: .trailing)
                    .padding(8)
            }.accessibility(label: Text("Close"))
            .accessibility(identifier: "close-button")
        }
    }

    private func closeButtonTapped() {
        isPresented = false
    }
}
