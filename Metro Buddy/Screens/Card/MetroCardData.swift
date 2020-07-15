import Foundation
import MetroKit

/// Represents the contents of the Metro Card to display on the overview screen.
struct MetroCardData {
    let source: ObjectReference<MetroCard>
    let formattedBalance: String
    let formattedExpirationDate: String?
    let formattedSerialNumber: String?
    let formattedFare: String
    let formattedRemainingSwipes: String
}
