import SwiftUI

struct FlexibleStack<Content: View>: View {
    let content: Content
    let hStackAlignment: VerticalAlignment
    let vStackAlignment: HorizontalAlignment
    @Environment(\.sizeCategory) var sizeCategory

    init(hStackAlignment: VerticalAlignment, vStackAlignment: HorizontalAlignment, @ViewBuilder content: () -> Content) {
        self.hStackAlignment = hStackAlignment
        self.vStackAlignment = vStackAlignment
        self.content = content()
    }

    var body: some View {
        if sizeCategory.mby_isAccessibilityCategory {
            return VStack(alignment: vStackAlignment, spacing: 16) {
                content
            }.eraseToAnyView()
        } else {
            return HStack(alignment: hStackAlignment, spacing: 8) {
                content
            }.eraseToAnyView()
        }
    }
}
