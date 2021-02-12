import Foundation
import MetroKit

extension BalanceUpdate {
    /// Returns a fake swipe of $2.75 with the specified date.
    static func swipe(timestamp: Date) -> BalanceUpdate {
        BalanceUpdate(id: UUID(), updateType: .swipe, amount: 2.75, timestamp: timestamp)
    }

    /// Returns a fake adjustment of $25 with the specified date.
    static func adjustment(timestamp: Date) -> BalanceUpdate {
        BalanceUpdate(id: UUID(), updateType: .adjustment, amount: 25, timestamp: timestamp)
    }
}
