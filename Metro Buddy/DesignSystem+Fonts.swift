import Foundation
import SwiftUI

enum DesignSystemComponent {
    struct FontAttributes {
        let component: DesignSystemComponent
        
        var weight: UIFont.Weight {
            switch component {
            case .sheetTitle, .screenTitle, .cardTitle:
                return .bold
            case .caption:
                return .medium
            case .button:
                return .semibold
            case .tooltip:
                return .semibold
            }
        }
        
        var textStyle: UIFont.TextStyle {
            switch component {
            case .sheetTitle:
                return .title1
            case .screenTitle:
                return .largeTitle
            case .caption:
                return .caption1
            case .button:
                return .callout
            case .cardTitle:
                return .headline
            case .tooltip:
                return .body
            }
        }
        
        var design: UIFontDescriptor.SystemDesign {
            switch component {
            case .sheetTitle, .screenTitle, .cardTitle:
                return .rounded
            case .caption, .button:
                return .default
            case .tooltip:
                return .monospaced
            }
        }
    }
    
    case sheetTitle
    case screenTitle
    case caption
    case button
    case cardTitle
    case tooltip

    var font: FontAttributes {
        FontAttributes(component: self)
    }
}

struct DynamicFontModifier: ViewModifier {
    let font: DesignSystemComponent.FontAttributes
    @Environment(\.sizeCategory) var sizeCategory
    
    init(font: DesignSystemComponent.FontAttributes) {
        self.font = font
    }
    
    func body(content: Content) -> some View {
        let traits = UITraitCollection(preferredContentSizeCategory: sizeCategory.objcValue)
        
        let fontDescriptor = UIFontDescriptor
            .preferredFontDescriptor(withTextStyle: font.textStyle, compatibleWith: traits)
            .withDesign(font.design)!
            .withWeight(font.weight)
        
        let font = UIFont(descriptor: fontDescriptor, size: 0)
        return content.font(Font(font))
    }
}

extension View {
    func component(_ component: DesignSystemComponent) -> some View {
        modifier(DynamicFontModifier(font: component.font))
    }
}

extension UIFontDescriptor {
    func withWeight(_ weight: UIFont.Weight) -> UIFontDescriptor {
        var traits = fontAttributes[.traits, default: [:]] as! [UIFontDescriptor.TraitKey: Any]
        traits[.weight] = weight.rawValue
        
        return addingAttributes([.traits: traits])
    }
}

extension ContentSizeCategory {
    var objcValue: UIContentSizeCategory {
        switch self {
        case .accessibilityExtraExtraExtraLarge:
            return .accessibilityExtraExtraExtraLarge
        case .accessibilityExtraExtraLarge:
            return .accessibilityExtraExtraLarge
        case .accessibilityExtraLarge:
            return .accessibilityExtraLarge
        case .accessibilityLarge:
            return .accessibilityLarge
        case .accessibilityMedium:
            return .accessibilityMedium
        case .extraExtraExtraLarge:
            return .extraExtraExtraLarge
        case .extraExtraLarge:
            return .extraExtraLarge
        case .extraLarge:
            return .extraLarge
        case .large:
            return .large
        case .medium:
            return .medium
        case .small:
            return .small
        case .extraSmall:
            return .extraSmall
        @unknown default:
            return .large
        }
    }
}
