import SwiftUI

/// A sheet that lets the user pick an expiration date for their card.
struct ExpirationDatePickerSheet: View {
    @Binding var isPresented: Bool
    let saveHandler: (Date) -> Void
    let resetHandler: () -> Void
    let hasInitialSelection: Bool

    @State private var selectedDate: Date

    // MARK: - Initialization
    
    init(initialValue: Date?, isPresented: Binding<Bool>, saveHandler: @escaping (Date) -> Void, resetHandler: @escaping () -> Void) {
        self.saveHandler = saveHandler
        self.resetHandler = resetHandler
        self.hasInitialSelection = initialValue != nil
        self._isPresented = isPresented
        self._selectedDate = State(initialValue: initialValue ?? Date())
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Expiration Date")
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
            }.padding(.horizontal, 16)
            .padding(.top, 16)

            DatePicker("Expiration Date", selection: $selectedDate, displayedComponents: [.date])
                .labelsHidden()
                .datePickerStyle(WheelDatePickerStyle())
                .minimumScaleFactor(0.1)

            RoundedButton(
                title: Text("Save"),
                titleColor: .black,
                background: Color.accentColor,
                design: .standard,
                action: saveButtonTapped
            ).padding(.horizontal, 16)
            .accessibility(identifier: "save-button")
            .padding(.bottom, hasInitialSelection ? 0 : 8)

            if hasInitialSelection {
                Button(action: resetButtonTapped) {
                    Text("Remove Expiration")
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(.accentColor)
                        .minimumScaleFactor(0.1)
                        .lineLimit(1)
                        .padding(8)
                }.padding(.horizontal, 16)
                .padding(.bottom, 8)
                .accessibility(identifier: "remove-date-button")
            }
        }.background(Color.contentBackground)
        .mask(RoundedRectangle.defaultStyle)
        .padding(.horizontal, UIDatePicker.isUltraCompact ? 0 : 16)
    }
    
    // MARK: - Input
    
    private func closeButtonTapped() {
        withAnimation {
            isPresented = false
        }
    }
    
    private func resetButtonTapped() {
        withAnimation {
            resetHandler()
            isPresented = false
        }
    }
    
    private func saveButtonTapped() {
        withAnimation {
            saveHandler(selectedDate)
            isPresented = false
        }
    }
}

// MARK: - Helpers

extension UIDatePicker {
    fileprivate static var isUltraCompact: Bool {
        return UIScreen.main.bounds.width < 375
    }
}
