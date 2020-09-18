import Foundation

/// A protocol that gives access to the widget center, enabling the app to request reloading the widgets.
public protocol WidgetCenterType {
    /// Reloads the timelines for all widgets of a particular kind.
    /// - parameter kind:The kind of widget associated with the value used when creating the widget configuration..
    func reloadTimelines(ofKind kind: WidgetKind)

    /// Reloads the timelines for all configured widgets belonging to the app.
    func reloadAllTimelines()
}

#if canImport(WidgetKit)
import WidgetKit

@available(iOS 14.0, *)
extension WidgetCenter: WidgetCenterType {
    public func reloadTimelines(ofKind kind: WidgetKind) {
        reloadTimelines(ofKind: kind.rawValue)
    }
}
#endif
