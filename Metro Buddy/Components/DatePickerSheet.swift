import SwiftUI

/// A sheet that lets the user pick an expiration date for their card.
struct ExpirationDatePickerSheet: View {
    @Binding var isPresented: Bool
    let saveHandler: (Date) -> Void
    let resetHandler: () -> Void

    @State private var selectedDate: Date

    // MARK: - Initialization
    
    init(initialValue: Date?, isPresented: Binding<Bool>, saveHandler: @escaping (Date) -> Void, resetHandler: @escaping () -> Void) {
        self.saveHandler = saveHandler
        self.resetHandler = resetHandler
        self._isPresented = isPresented
        self._selectedDate = State(initialValue: initialValue ?? Date())
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Expiration Date")
                    .component(.sheetTitle)
                
                Spacer()
                
                Button(action: closeButtonTapped) {
                    Image(systemName: "xmark.circle.fill")
                        .component(.sheetTitle)
                }
            }
            
            DatePicker("Expiration Date", selection: $selectedDate, displayedComponents: [.date])
                .labelsHidden()
                .datePickerStyle(WheelDatePickerStyle())
            
            RoundedButton(
                title: Text("Save"),
                titleColor: .black,
                background: Color.accentColor,
                padding: .standard,
                action: saveButtonTapped
            )
            
            Button(action: resetButtonTapped) {
                Text("Remove Expiration")
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.accentColor)
                    .padding(8)
            }
        }.padding(20)
        .background(Color.contentBackground)
        .mask(RoundedRectangle.defaultStyle)
        .padding(20)
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
