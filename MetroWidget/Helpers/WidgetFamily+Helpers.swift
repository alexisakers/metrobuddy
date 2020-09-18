import WidgetKit

extension WidgetFamily {
    /// Indicates whether the widget's layout is compact.
    var isCompact: Bool {
        switch self {
        case .systemSmall:
            return true
        case .systemMedium, .systemLarge:
            return false
        @unknown default:
            fatalError("Unknown cases should be handled.")
        }
    }
}
