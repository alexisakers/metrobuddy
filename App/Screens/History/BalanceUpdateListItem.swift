import Foundation
import MetroKit

/// The contents of the balance update row.
struct BalanceUpdateListItem: Identifiable {
    let id: UUID
    let formattedAmount: String
    let formattedTimestamp: String
    let updateType: BalanceUpdate.UpdateType
}
