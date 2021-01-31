import SwiftUI

/// A view that contains the basics of a list row, with a spacer around the content and a separator if needed.
struct Row<Content: View>: View {
    @Environment(\.sizeCategory) var sizeCategory

    let content: Content
    let needsSeparator: Bool
    let roundedCorners: UIRectCorner

    init(needsSeparator: Bool, roundedCorners: UIRectCorner, @ViewBuilder content: () -> Content) {
        self.needsSeparator = needsSeparator
        self.roundedCorners = roundedCorners
        self.content = content()
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            content
                .padding(.horizontal, 16)
                .padding(.vertical, sizeCategory.mby_isAccessibilityCategory ? 16 : 8)

            if needsSeparator {
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color(.separator))
            }
        }
        .background(
            PartialRoundedRectangle(
                roundedCorners: roundedCorners,
                cornerRadius: 16
            )
            .foregroundColor(Color(.systemGroupedBackground))
        )
    }
}
