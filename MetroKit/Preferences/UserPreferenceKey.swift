import Foundation

public protocol UserPreferenceKey {
    associatedtype Value: PropertyListConvertible
    static var name: String { get }
    static var defaultValue: Value { get }
}

public enum UserDidOnboardPreferenceKey: UserPreferenceKey {
    public static let name: String = "UserDidOnboard"
    public static let defaultValue: Bool = false
}
