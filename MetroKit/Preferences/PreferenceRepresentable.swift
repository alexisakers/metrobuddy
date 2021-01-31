import Foundation

/// An object that can be stored in the UserDefaults.
public protocol PreferenceRepresentable {
    associatedtype PreferenceValue
    init?(preferenceValue: PreferenceValue)
    var preferenceValue: PreferenceValue { get }
}

extension PropertyListRepresentable {
    public init(preferenceValue: Self) {
        self = preferenceValue
    }

    public var preferenceValue: Self {
        return self
    }
}

// MARK: PreferenceRepresentable+Enum

/// An enum that can be stored in the UserDefaults.
public protocol PreferenceRepresentableEnum: RawRepresentable, PreferenceRepresentable {}

extension PreferenceRepresentableEnum {
    public init?(preferenceValue: RawValue) {
        self.init(rawValue: preferenceValue)
    }

    public var preferenceValue: RawValue {
        rawValue
    }
}
