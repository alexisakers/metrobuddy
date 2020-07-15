import SwiftUI

struct ModalSheet<Content: View>: View {
    @Binding var isPresented: Bool
    let content: Content
    
    init(isPresented: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self._isPresented = isPresented
        self.content = content()
    }
        
    var body: some View {
        ZStack(alignment: .center) {
            Color.black.opacity(0.75)
                .edgesIgnoringSafeArea(.all)
                .zIndex(0)
                .onTapGesture {
                    withAnimation {
                        isPresented = false
                    }
                }
            
            content
        }
    }
}
