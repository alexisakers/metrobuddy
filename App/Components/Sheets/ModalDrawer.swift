import SwiftUI

/// A view that displays modal content on top of a view that dims the content underneath.
private struct ModalDrawerContainer<Source: View, Sheet: View>: View {
    let source: Source
    let content: Sheet
    @Binding var isPresented: Bool

    var body: some View {
        ZStack(alignment: .bottom) {
            source
                .zIndex(0)
                .accessibility(hidden: isPresented)

            Color.black.opacity(isPresented ? 0.75 : 0)
                .onTapGesture(perform: closeActionActivated)
                .disabled(!isPresented)
                .edgesIgnoringSafeArea(.all)
                .accessibility(hidden: true)
                .zIndex(1)

            if isPresented {
                content
                    .edgesIgnoringSafeArea(.bottom)
                    .accessibility(sortPriority: 1)
                    .zIndex(2)
            }
        }.edgesIgnoringSafeArea(.bottom)
        .accessibilityAction(.escape, closeActionActivated)
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
        ModalDrawerContainer(source: self, content: content(), isPresented: isPresented)
    }
}
