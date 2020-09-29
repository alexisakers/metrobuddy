import Foundation

extension NumberFormatter {
    /// Returns a number formatter configured to display a currency.
    public static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.currencyCode = "USD"
        formatter.numberStyle = .currency
        return formatter
    }()
}
