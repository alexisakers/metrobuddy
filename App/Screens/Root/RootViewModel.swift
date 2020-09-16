import Combine
import Foundation
import MetroKit

#if canImport(WidgetKit)
import WidgetKit
#endif

/// The view model of the root view, responsible for calculating the state of the app.
final class RootViewModel {
    /// The possible contents that can be displayed by the app.
    enum Content {
        /// The app is not available because of an error, described by the given message.
        case appUnavailable(ErrorMessage)
        
        /// The card is available and can be viewed and edited.
        case card(MetroCardViewModel)
    }
    
    /// The content to display, calculated in function of the app's state.
    @Published var content: Content
    
    // MARK: - Initialization
    
    init(dataStore: MetroCardDataStore, preferences: UserPreferences) {
        do {
            let initialCard = try dataStore.currentCard()
            var widgetCenter: WidgetCenterType? = nil

            #if canImport(WidgetKit)
            if #available(iOS 14, *) {
                widgetCenter = WidgetCenter.shared
            } else {
                widgetCenter = nil
            }
            #endif

            let viewModel = MetroCardViewModel(
                card: initialCard,
                dataStore: dataStore,
                preferences: preferences,
                widgetCenter: widgetCenter
            )
            
            content = .card(viewModel)
        } catch {
            let errorTitle = NSLocalizedString("Unexpected Issue", comment: "")
            let message = ErrorMessage(title: errorTitle, error: error)
            content = .appUnavailable(message)
        }
    }
}
