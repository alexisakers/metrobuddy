import SwiftUI
import UIKit

extension UIContentSizeCategory {
    /// Converts a SwiftUI content size category to a `UIContentSizeCategory`.
    init(_ contentSizeCategory: ContentSizeCategory) {
        switch contentSizeCategory {
        case .extraSmall:
            self = .extraSmall
        case .small:
            self = .small
        case .medium:
            self = .medium
        case .large:
            self = .large
        case .extraLarge:
            self = .extraLarge
        case .extraExtraLarge:
            self = .extraExtraLarge
        case .extraExtraExtraLarge:
            self = .extraExtraExtraLarge
        case .accessibilityMedium:
            self = .accessibilityMedium
        case .accessibilityLarge:
            self = .accessibilityLarge
        case .accessibilityExtraLarge:
            self = .accessibilityExtraLarge
        case .accessibilityExtraExtraLarge:
            self = .accessibilityExtraExtraLarge
        case .accessibilityExtraExtraExtraLarge:
            self = .accessibilityExtraExtraExtraLarge
        @unknown default:
            self = .large
        }
    }
}

extension ContentSizeCategory {
    /// A reimplementation of `isAccessibilityCategory` that works on iOS 13.0 to iOS 13.3.
    var mby_isAccessibilityCategory: Bool {
        if #available(iOS 13.4, *) {
            return isAccessibilityCategory
        } else {
            return UIContentSizeCategory(self).isAccessibilityCategory
        }
    }
}
