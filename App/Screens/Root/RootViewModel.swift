import Combine
import Foundation
import MetroKit
import WidgetKit

/// The view model of the root view, responsible for calculating the state of the app.
final class RootViewModel {
    /// An object that contains the child view models of the root screen.
    struct ViewModels {
        /// The view model for the card overview.
        let card: MetroCardViewModel

        /// The view model for the history screen.
        let history: HistoryViewModel
    }

    /// The possible contents that can be displayed by the app.
    enum Content {
        /// The app is not available because of an error, described by the given message.
        case appUnavailable(ErrorMessage)
        
        /// The card is available and can be viewed and edited.
        case card(ViewModels)
    }
    
    /// The content to display, calculated in function of the app's state.
    @Published var content: Content
    
    // MARK: - Initialization
    
    init(dataStore: MetroCardDataStore, preferences: UserPreferences) {
        do {
            let initialCard = try dataStore.currentCard()
            let widgetCenter: WidgetCenterType = WidgetCenter.shared

            let viewModels = ViewModels(
                card: MetroCardViewModel(
                    card: initialCard,
                    dataStore: dataStore,
                    preferences: preferences,
                    widgetCenter: widgetCenter
                ),
                history: HistoryViewModel(
                    card: initialCard,
                    dataStore: dataStore
                )
            )
            
            content = .card(viewModels)
        } catch {
            let errorTitle = NSLocalizedString("Unexpected Issue", comment: "")
            let message = ErrorMessage(title: errorTitle, error: error)
            content = .appUnavailable(message)
        }
    }
}
