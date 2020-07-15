import Foundation

/// Represents the updates that can be performed on a metro card object.
public enum MetroCardUpdate {
    case balance(Decimal)
    case expirationDate(Date?)
    case serialNumber(String?)
    case fare(Decimal)
}
