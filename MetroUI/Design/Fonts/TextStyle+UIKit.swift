import SwiftUI
import UIKit

extension UIFont.TextStyle {
    init(_ textStyle: Font.TextStyle) {
        switch textStyle {
        case .body:
            self = .body
        case .largeTitle:
            self = .largeTitle
        case .title:
            self = .title1
        case .title2:
            self = .title2
        case .title3:
            self = .title3
        case .headline:
            self = .headline
        case .subheadline:
            self = .subheadline
        case .callout:
            self = .callout
        case .footnote:
            self = .footnote
        case .caption:
            self = .caption1
        case .caption2:
            self = .caption2
        @unknown default:
            fatalError("Unknown cases must be handled.")
        }
    }
}
