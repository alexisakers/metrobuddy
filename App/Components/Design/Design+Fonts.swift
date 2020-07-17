import Foundation
import SwiftUI

extension Font {
    static var cardBalance: Font {
        Font.system(size: 50, weight: .bold, design: .rounded)
            .monospacedDigit()
    }
    
    static var screenTitle: Font {
        Font.largeTitle
            .bold()
    }
    
    static var sheetTitle: Font {
        Font.title
            .bold()
    }
    
    static var contentCardTitle: Font {
        Font.headline.bold()
    }
    
    static var cardActionTitle: Font {
        Font.caption
            .weight(.medium)
            .uppercaseSmallCaps()
    }
    
    static var buttonTitle: Font {
        Font.body
            .weight(.semibold)
    }

    static var toastText: UIFont {
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
    func font(_ uiFont: UIFont, textStyle: UIFont.TextStyle) -> some View {
        let scaleFont = ScaleFontModifier(font: uiFont, textStyle: textStyle)
        return modifier(scaleFont)
    }
}

extension UIFontDescriptor {
    func withWeight(_ weight: UIFont.Weight) -> UIFontDescriptor {
        var traits = self.fontAttributes[.traits, default: [:]] as! [TraitKey: Any]
        traits[.weight] = weight.rawValue
        return self.addingAttributes([.traits: traits])
    }
}
