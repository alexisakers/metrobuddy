import SwiftUI

/// A scroll view that fills the entire width of the screen.
struct FullWidthScrollView<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                self.content
                    .frame(width: geometry.size.width)
            }.frame(width: geometry.size.width)
        }
    }
}
