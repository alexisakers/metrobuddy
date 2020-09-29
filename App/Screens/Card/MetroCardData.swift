import Foundation
import MetroKit

/// Represents the contents of the Metro Card to display on the overview screen.
struct MetroCardData {
    /// Whether the user finished onboarding the card.
    let isOnboarded: Bool
    
    /// The balance of the card, formatted for display.
    let formattedBalance: String
    
    /// The expiration date that the user entered.
    let expirationDate: Date?
    
    /// The expiration date, formatted for display.
    let formattedExpirationDate: String?

    /// The serial number the user entered.
    let formattedSerialNumber: String?

    /// The current fare, formatted for display.
    let formattedFare: String

    /// The number of remaining rides, formatted for display and pluralized if needed.
    let formattedRemainingRides: String
}
