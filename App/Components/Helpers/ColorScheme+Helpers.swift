import SwiftUI
import UIKit

extension UIUserInterfaceStyle {
    /// Converts a SwiftUI color scheme to a 
    init(_ colorScheme: ColorScheme) {
        switch colorScheme {
        case .light:
            self = .light
        case .dark:
            self = .dark
        @unknown default:
            self = .unspecified
        }
    }
}
