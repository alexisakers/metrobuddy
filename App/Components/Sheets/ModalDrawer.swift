import SwiftUI

/// A structure that contains the necessary elements to draw a sheet card.
struct ModalDrawer<Content: View> {
    let builder: () -> Content
}

/// A view that displays modal content on top of a view that dims the content underneath.
private struct ModalDrawerContainer<Source: View, Sheet: View>: View {
    let source: Source
    @Binding var drawer: ModalDrawer<Sheet>?

    var isPresented: Bool {
        drawer != nil
    }

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

            if let drawer = drawer {
                drawer.builder()
                    .transition(.move(edge: .bottom))
                    .edgesIgnoringSafeArea(.bottom)
                    .accessibility(sortPriority: 1)
                    .zIndex(2)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .accessibilityAction(.escape, closeActionActivated)
    }

    func closeActionActivated() {
        withAnimation {
            drawer = nil
        }
    }
}

extension View {
    /// Presents the specified content as a modal drawer.
    func modalDrawer<Sheet: View>(drawer: Binding<ModalDrawer<Sheet>?>) -> some View {
        ModalDrawerContainer(source: self, drawer: drawer)
    }
}
