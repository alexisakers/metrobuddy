import Foundation
import WidgetKit
import MetroKit

/// An object that provides the current card details to the widget timeline.
class MetroTimelineProvider: TimelineProvider {
    let dataStore: MetroCardDataStore

    init() {
        self.dataStore = try! PersistentMetroCardDataStore(
            preferences: UserDefaults.sharedSuite,
            persistentStore: .sharedContainer,
            useCloudKit: true
        )
    }

    func currentEntry() -> MetroTimelineEntry {
        do {
            let currentCard = try dataStore.currentCard()
            let remainingRides = currentCard.remainingRides
            let formattedBalance = NumberFormatter.currencyFormatter.string(from: currentCard.balance as NSDecimalNumber)!

            let remainingRidesFormat = NSLocalizedString("%ld left", comment: "The first argument is the number of rides left.")
            let formattedRides = String.localizedStringWithFormat(remainingRidesFormat, remainingRides)

            let accessibleFormattedRides = String.localizedStringWithFormat(
                String.LocalizationFormats.remainingRides,
                currentCard.remainingRides
            )

            let status = MetroTimelineEntry.CardStatus(
                balance: formattedBalance,
                remainingRides: formattedRides,
                isPlaceholder: false,
                accessibilityValue: [formattedBalance, accessibleFormattedRides].joined(separator: ", ")
            )

            return MetroTimelineEntry(date: Date(), cardStatus: status)
        } catch {
            return MetroTimelineEntry(date: Date(), cardStatus: .placeholder)
        }
    }

    // MARK: - TimelineProvider

    func placeholder(in context: Context) -> MetroTimelineEntry {
        return MetroTimelineEntry(date: Date(), cardStatus: .placeholder)
    }

    func getSnapshot(in context: Context, completion: @escaping (MetroTimelineEntry) -> ()) {
        completion(currentEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<MetroTimelineEntry>) -> ()) {
        completion(Timeline(entries: [currentEntry()], policy: .never))
    }
}
