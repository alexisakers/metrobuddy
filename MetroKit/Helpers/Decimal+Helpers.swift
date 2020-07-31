import Foundation

extension Decimal {
    /// Returns the result of the division between the receiver and another decimal as the quotient and remainder.
    /// - parameter divisior: The number to divide the receiver by.
    /// - returns: The result of the division.
    func quotientAndRemainer(dividingBy divisor: Decimal) -> (quotient: Int, remainder: Decimal) {
        let dividend = self as NSDecimalNumber
        let divisor = divisor as NSDecimalNumber
        let behavior = NSDecimalNumberHandler(roundingMode: .down, scale: 0, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        
        let quotient = dividend
            .dividing(by: divisor, withBehavior: behavior)
        let subtractAmount = quotient.multiplying(by: divisor)
        let remainder = dividend.subtracting(subtractAmount)

        return (quotient.intValue, remainder as Decimal)
    }
}
