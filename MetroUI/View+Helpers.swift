import SwiftUI

extension View {
    /// A modifier that erases the type of the view.
    /// - returns : An `AnyView` that wraps the receiver.
    public func eraseToAnyView() -> AnyView {
        return AnyView(self)
    }
}
