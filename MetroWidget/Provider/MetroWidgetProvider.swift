import Foundation
import WidgetKit
import MetroKit

/// An object that provides the current card details to the widget timeline.
class MetroTimelineProvider: TimelineProvider {
    let dataStore: MetroCardDataStore
    let balanceFormatter: NumberFormatter

    init() {
        self.dataStore = try! PersistentMetroCardDataStore(
            preferences: UserDefaults.sharedSuite,
            persistentStore: .sharedContainer,
            useCloudKit: true
        )

        self.balanceFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.currencyCode = "USD"
            return formatter
        }()
    }

    func currentEntry() -> MetroTimelineEntry {
        do {
            let currentCard = try dataStore.currentCard()
            let remainingSwipes = currentCard.remainingSwipes
            let formattedBalance = balanceFormatter.string(from: currentCard.balance as NSDecimalNumber)!

            let remainingSwipesFormat = NSLocalizedString("%ld left", comment: "The first argument is the number of rides left.")
            let formattedSwipes = String.localizedStringWithFormat(remainingSwipesFormat, remainingSwipes)

            let accessibleFormattedRides = String.localizedStringWithFormat(
                String.LocalizationFormats.remainingSwipes,
                currentCard.remainingSwipes
            )

            let status = MetroTimelineEntry.CardStatus(
                balance: formattedBalance,
                remainingSwipes: formattedSwipes,
                isPlaceholder: false,
                accessibilityValue: [formattedBalance, accessibleFormattedRides].joined(separator: ", ")
            )

            return MetroTimelineEntry(date: Date(), cardStatus: status)
        } catch {
            return MetroTimelineEntry(date: Date(), cardStatus: .placeholder)
        }
    }

    // MARK: - TimelineProvider

    func placeholder(with: Context) -> MetroTimelineEntry {
        return MetroTimelineEntry(date: Date(), cardStatus: .placeholder)
    }

    func snapshot(with context: Context, completion: @escaping (MetroTimelineEntry) -> ()) {
        completion(currentEntry())
    }

    func timeline(with context: Context, completion: @escaping (Timeline<MetroTimelineEntry>) -> ()) {
        completion(Timeline(entries: [currentEntry()], policy: .never))
    }
}
