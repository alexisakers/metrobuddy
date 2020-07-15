import Combine
import Foundation
import MetroKit

class RootViewModel {
    enum Content {
        case appUnavailable(Error)
        case card(MetroCardViewModel)
    }
    
    @Published var content: Content
    
    init(dataStore: MetroCardDataStore, preferences: Preferences) {
        do {
            let initialCard = try dataStore.currentCard()
            let viewModel = MetroCardViewModel(card: initialCard, dataStore: dataStore, preferences: preferences)
            content = .card(viewModel)
        } catch {
            content = .appUnavailable(error)
        }
    }
}
