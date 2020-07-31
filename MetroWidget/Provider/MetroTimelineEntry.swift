import Foundation
import WidgetKit

/// An entry for a card in the timeline.
struct MetroTimelineEntry: TimelineEntry {
    /// Contains formatted details for the card status.
    struct CardStatus {
        let balance: String
        let remainingSwipes: String
        let isPlaceholder: Bool
    }

    var date: Date
    let cardStatus: CardStatus
}

// MARK: - Placeholder

extension MetroTimelineEntry.CardStatus {
    /// The card status to display when we are showing a placeholder.
    static var placeholder: Self {
        Self(balance: "$25.00", remainingSwipes: "0 swipes", isPlaceholder: true)
    }
}
