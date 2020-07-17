import SwiftUI

/// A view that displays modal content on top of a view that dims the content underneath.
struct ModalSheet<Content: View>: View {
    @Binding var isPresented: Bool
    let content: Content

    // MARK: - Initialization

    init(isPresented: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self._isPresented = isPresented
        self.content = content()
    }

    // MARK: - View

    var body: some View {
        ZStack(alignment: .center) {
            Color.black.opacity(0.75)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture(perform: closeActionActivated)
                .zIndex(0)
            
            content
                .zIndex(1)
        }.accessibilityAction(.magicTap, closeActionActivated)
    }

    private func closeActionActivated() {
        withAnimation {
            isPresented = false
        }
    }
}
