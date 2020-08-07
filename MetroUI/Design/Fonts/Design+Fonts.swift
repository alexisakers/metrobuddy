import Foundation
import SwiftUI

extension Font {
    public static var cardBalance: Font {
        Font.system(size: 50, weight: .bold, design: .rounded)
            .monospacedDigit()
    }
    
    public static var screenTitle: Font {
        Font.largeTitle
            .bold()
    }
    
    public static var sheetTitle: Font {
        Font.title
            .bold()
    }
    
    public static var contentCardTitle: Font {
        Font.headline.bold()
    }
    
    public static var cardActionTitle: Font {
        Font.caption
            .weight(.medium)
            .uppercaseSmallCaps()
    }
    
    public static var buttonTitle: Font {
        Font.body
            .weight(.semibold)
    }

    public static var toastText: UIFont {
        let fontDescriptor = UIFont.preferredFont(forTextStyle: .body)
            .fontDescriptor
            .withDesign(.monospaced)!
            .withWeight(.semibold)

        return UIFont(descriptor: fontDescriptor, size: 0)
    }
}

// MARK: - Custom Dynamic Fonts

struct ScaleFontModifier: ViewModifier {
    let font: UIFont
    let textStyle: UIFont.TextStyle
    @Environment(\.sizeCategory) var sizeCategory

    func body(content: Content) -> some View {
        let metrics = UIFontMetrics(forTextStyle: textStyle)
        let traits = UITraitCollection(preferredContentSizeCategory: UIContentSizeCategory(sizeCategory))
        let scaledFont = metrics.scaledFont(for: font, compatibleWith: traits)
        return content.font(Font(scaledFont))
    }
}

extension View {
    public func font(_ uiFont: UIFont, textStyle: UIFont.TextStyle) -> some View {
        let scaleFont = ScaleFontModifier(font: uiFont, textStyle: textStyle)
        return modifier(scaleFont)
    }
}

extension UIFontDescriptor {
    public func withWeight(_ weight: UIFont.Weight) -> UIFontDescriptor {
        var traits = self.fontAttributes[.traits, default: [:]] as! [TraitKey: Any]
        traits[.weight] = weight.rawValue
        return self.addingAttributes([.traits: traits])
    }
}
