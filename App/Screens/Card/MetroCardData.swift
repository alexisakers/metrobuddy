import Foundation
import MetroKit

/// Represents the contents of the Metro Card to display on the overview screen.
struct MetroCardData {
    /// Whether the user finished onboarding the card.
    let isOnboarded: Bool
    
    /// The formatted balance of the card.
    let formattedBalance: String
    
    /// The expiration date that the user entered.
    let expirationDate: Date?
    
    /// The
    let formattedExpirationDate: String?

    let formattedSerialNumber: String?

    let formattedFare: String

    let formattedRemainingSwipes: String
}
