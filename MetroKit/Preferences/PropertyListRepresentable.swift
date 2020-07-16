import Foundation

/// An object for types that can be included in a property list file.
public protocol PropertyListRepresentable {}

// MARK: - Default Types

extension Int: PropertyListRepresentable {}
extension Int8: PropertyListRepresentable {}
extension Int16: PropertyListRepresentable {}
extension Int32: PropertyListRepresentable {}
extension Int64: PropertyListRepresentable {}
extension UInt: PropertyListRepresentable {}
extension UInt8: PropertyListRepresentable {}
extension UInt16: PropertyListRepresentable {}
extension UInt32: PropertyListRepresentable {}
extension UInt64: PropertyListRepresentable {}
extension Float: PropertyListRepresentable {}
extension Double: PropertyListRepresentable {}
extension NSNumber: PropertyListRepresentable {}

extension String: PropertyListRepresentable {}
extension NSString: PropertyListRepresentable {}

extension Bool: PropertyListRepresentable {}

extension Data: PropertyListRepresentable {}
extension NSData: PropertyListRepresentable {}
