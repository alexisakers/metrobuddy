import SwiftUI
import UIKit

private struct FontScalingModifier: ViewModifier {
    let textStyle: UIFont.TextStyle
    let maximumPointSize: CGFloat

    @Environment(\.sizeCategory) private var sizeCategory

    func body(content: Content) -> some View {
        let contentSizeCategory = UIContentSizeCategory(sizeCategory)
        let traitCollection = UITraitCollection(preferredContentSizeCategory: contentSizeCategory)

        let font = UIFont.preferredFont(forTextStyle: textStyle, compatibleWith: traitCollection)
        let fontMetrics = UIFontMetrics(forTextStyle: textStyle)
        let scaledFont = fontMetrics.scaledFont(for: font, maximumPointSize: maximumPointSize, compatibleWith: traitCollection)

        return content
            .font(Font(scaledFont))
    }
}

extension View {
    /// Applies a font that automatically scales for Dynamic Type to the view, while respecting a maximum point size.
    /// - parameter textStyle: The style of the text, used to determine how to scale the font.
    /// - parameter maximumPointSize: The maximum allowed size for the font.
    public func font(textStyle: Font.TextStyle, maximumPointSize: CGFloat) -> some View {
        return self
            .modifier(
                FontScalingModifier(textStyle: UIFont.TextStyle(textStyle), maximumPointSize: maximumPointSize)
            )
    }
}
