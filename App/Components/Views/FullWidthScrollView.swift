import SwiftUI
import Introspect

/// A scroll view that fills the entire width of the screen.
struct FullWidthScrollView<Content: View>: View {
    let bounce: Axis.Set
    let content: Content

    init(bounce: Axis.Set, @ViewBuilder content: () -> Content) {
        self.bounce = bounce
        self.content = content()
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                self.content
                    .frame(width: geometry.size.width)
            }.frame(width: geometry.size.width)
        }.introspectScrollView {
            // Temporary solution until SwiftUI exposes APIs to disable bouncing, see FB8072964
            $0.alwaysBounceVertical = self.bounce.contains(.vertical)
            $0.alwaysBounceHorizontal = self.bounce.contains(.horizontal)
        }
    }
}
