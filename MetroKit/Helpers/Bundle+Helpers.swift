import Foundation

extension Bundle {
    private class Token {}

    static var metroKit: Bundle {
        Bundle(for: Token.self)
    }
}
