import MetroKit
import SwiftUI
import Combine

/// An object responsible for computing the content of the history screen, and which side effects to display when the data changes.
class HistoryViewModel: ObservableObject {
    enum Content {
        case loading
        case empty
        case history([BalanceUpdateListItem])
    }

    @Published var content: Content = .loading

    private let card: ObjectReference<MetroCard>
    private let dataStore: MetroCardDataStore
    private let dateFormatter: DateFormatter
    private var cancellables: Set<AnyCancellable> = []

    init(card: ObjectReference<MetroCard>, dataStore: MetroCardDataStore) {
        self.card = card
        self.dataStore = dataStore

        self.dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
    }

    func load() {
        dataStore.balanceUpdatesPublisher(for: card)
            .map {
                $0.map { update in
                    BalanceUpdateListItem(
                        id: update.id,
                        formattedAmount: NumberFormatter.currencyFormatter.string(from: update.amount as NSDecimalNumber) ?? "",
                        formattedTimestamp: self.dateFormatter.string(from: update.timestamp),
                        updateType: update.updateType
                    )
                }
            }.map(Content.history)
            .assign(to: \.content, on: self)
            .store(in: &cancellables)
    }
}
