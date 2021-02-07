import SwiftUI

struct FlexibleStack<Content: View>: View {
    let hStackAlignment: VerticalAlignment
    let vStackAlignment: HorizontalAlignment

    let contentBuilder: (Axis) -> Content
    @Environment(\.sizeCategory) private var sizeCategory

    init(hStackAlignment: VerticalAlignment, vStackAlignment: HorizontalAlignment, @ViewBuilder content: @escaping (Axis) -> Content) {
        self.hStackAlignment = hStackAlignment
        self.vStackAlignment = vStackAlignment
        self.contentBuilder = content
    }

    init(hStackAlignment: VerticalAlignment, vStackAlignment: HorizontalAlignment, @ViewBuilder content: @escaping () -> Content) {
        self.hStackAlignment = hStackAlignment
        self.vStackAlignment = vStackAlignment
        self.contentBuilder = { _ in content() }
    }

    var body: some View {
        if sizeCategory.isAccessibilityCategory {
            VStack(alignment: vStackAlignment, spacing: 16) {
                contentBuilder(.vertical)
            }
            .eraseToAnyView()
        } else {
            HStack(alignment: hStackAlignment, spacing: 8) {
                contentBuilder(.horizontal)
            }
            .eraseToAnyView()
        }
    }
}
