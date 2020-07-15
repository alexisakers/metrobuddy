import Foundation

public protocol PropertyListRepresentable: PropertyListConvertible {}

extension PropertyListRepresentable {
    public init(propertyListValue: Self) {
        self = propertyListValue
    }
    
    public var propertyListValue: Self {
        return self
    }
}

public protocol PropertyListConvertible {
    associatedtype PropertyListValue: PropertyListRepresentable
    init?(propertyListValue: PropertyListValue)
    var propertyListValue: PropertyListValue { get }
}

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
