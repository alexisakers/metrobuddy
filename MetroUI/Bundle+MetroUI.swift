import Foundation

extension Bundle {
    private class Token {}

    /// Returns the bundle of the MetroUI framework.
    static var metroUI: Bundle {
        Bundle(for: Token.self)
    }
}
