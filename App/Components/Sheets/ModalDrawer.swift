import SwiftUI

/// A view that displays modal content on top of a view that dims the content underneath.
private struct DrawerViewModifier<Source: View, Sheet: View>: ViewModifier {
    let source: Source
    let content: Sheet
    @Binding var isPresented: Bool

    func body(content: Content) -> AnyView {
        return ZStack(alignment: .bottom) {
            source
                .zIndex(0)

            Color.black.opacity(isPresented ? 0.75 : 0)
                .disabled(!isPresented)
                .onTapGesture(perform: closeActionActivated)
                .edgesIgnoringSafeArea(.all)

                .transition(.opacity)
                .zIndex(1)

            if isPresented {
                content
                    .edgesIgnoringSafeArea(.bottom)
                    .zIndex(2)
            }
        }.edgesIgnoringSafeArea(.bottom)
        .animation(.spring())
        .eraseToAnyView()
    }

    func closeActionActivated() {
        withAnimation {
            isPresented = false
        }
    }
}

extension View {
    /// Presents the specified content as a modal drawer.
    func modalDrawer<Content: View>(isPresented: Binding<Bool>, @ViewBuilder content: () -> Content) -> some View {
        modifier(DrawerViewModifier(source: self, content: content(), isPresented: isPresented))
    }
}
