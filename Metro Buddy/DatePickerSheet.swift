import SwiftUI

struct DatePickerSheet: View {
    @Binding var isPresented: Bool
    let saveHandler: (Date) -> Void
    let resetHandler: () -> Void

    @State private var selectedDate: Date

    init(initialValue: Date?, isPresented: Binding<Bool>, saveHandler: @escaping (Date) -> Void, resetHandler: @escaping () -> Void) {
        self.saveHandler = saveHandler
        self.resetHandler = resetHandler
        self._isPresented = isPresented
        self._selectedDate = State(initialValue: initialValue ?? Date())
    }
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Expiration Date")
                    .component(.sheetTitle)
                
                Spacer()
                Button(action: closeButtonTapped) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
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
        .background(Color("BackgroundColor"))
        .mask(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .padding(20)
    }
    
    func closeButtonTapped() {
        withAnimation {
            isPresented = false
        }
    }
    
    func resetButtonTapped() {
        withAnimation {
            resetHandler()
            isPresented = false
        }
    }
    
    func saveButtonTapped() {
        withAnimation {
            saveHandler(selectedDate)
            isPresented = false
        }
    }
}
