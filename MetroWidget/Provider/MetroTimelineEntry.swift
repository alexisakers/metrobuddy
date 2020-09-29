import Foundation
import WidgetKit

/// An entry for a card in the timeline.
struct MetroTimelineEntry: TimelineEntry {
    /// Contains formatted details for the card status.
    struct CardStatus {
        let balance: String
        let remainingRides: String
        let isPlaceholder: Bool
        let accessibilityValue: String
    }

    var date: Date
    let cardStatus: CardStatus
}

// MARK: - Placeholder

extension MetroTimelineEntry.CardStatus {
    /// The card status to display when we are showing a placeholder.
    static var placeholder: Self {
        Self(balance: "$25.00", remainingRides: "0 left", isPlaceholder: true, accessibilityValue: "$25, 0 rides left")
    }
}
