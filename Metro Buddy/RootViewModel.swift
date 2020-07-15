import Combine
import Foundation
import MetroKit

class RootViewModel {
    enum Content {
        case appUnavailable(ErrorMessage)
        case card(MetroCardViewModel)
    }
    
    @Published var content: Content
    
    init(dataStore: MetroCardDataStore, preferences: Preferences) {
        do {
            let initialCard = try dataStore.currentCard()
            let viewModel = MetroCardViewModel(card: initialCard, dataStore: dataStore, preferences: preferences)
            content = .card(viewModel)
        } catch {
            let errorTitle = NSLocalizedString("Unexpected Issue", comment: "")
            let message = ErrorMessage(title: errorTitle, error: error)
            content = .appUnavailable(message)
        }
    }
}
