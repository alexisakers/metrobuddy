import SwiftUI

/// A view that displays modal content on top of a view that dims the content underneath.
struct ModalSheet<Content: View>: View {
    @Binding var isPresented: Bool
    @Environment(\.enableAnimations) var enableAnimations

    let content: Content

    // MARK: - Initialization

    init(isPresented: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self._isPresented = isPresented
        self.content = content()
    }

    // MARK: - View

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black.opacity(0.75)
                .onTapGesture(perform: closeActionActivated)
                .zIndex(0)
            .transition(AnyTransition.opacity
                .animation(enableAnimations ? Animation.easeInOut(duration: 0.25) : nil)
            )
            
            content
                .zIndex(1)
                .transition(AnyTransition.move(edge: .top)
                .animation(enableAnimations ? Animation.easeInOut(duration: 0.25) : nil))
        }.accessibilityAction(.escape, closeActionActivated)
        .edgesIgnoringSafeArea(.all)
    }

    private func closeActionActivated() {
        isPresented = false
    }
}

extension View {
    func modalSheet<Item: Identifiable, Sheet: View>(item: Binding<Item?>, @ViewBuilder sheet: () -> Sheet) -> some View {
        ZStack {
            self


        }
    }
}
