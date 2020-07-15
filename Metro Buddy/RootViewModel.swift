import Combine
import Foundation
import MetroKit

struct AppError {
    let error: Error
    let localizedDescription: String
}

class RootViewModel {
    enum Content {
        case appUnavailable(AppError)
        case card(MetroCardViewModel)
    }
    
    @Published var content: Content
    
    init(dataStore: MetroCardDataStore, preferences: Preferences) {
        do {
            let initialCard = try dataStore.currentCard()
            let viewModel = MetroCardViewModel(card: initialCard, dataStore: dataStore, preferences: preferences)
            content = .card(viewModel)
        } catch {
            let description: String
            if let error = error as? LocalizedError, let localizedDescription = error.errorDescription {
                description = localizedDescription
            } else if let error = error as? CustomNSError, let localizedDescription = error.errorUserInfo[NSLocalizedDescriptionKey] as? String {
                description = localizedDescription
            } else {
                let descriptionFormat = NSLocalizedString("An unknown error occured (%@). Please reach out to us with reproduction steps and we will investigate the issue", comment: "A default error message. The parameter is a string of the non-localized error description.")
                description = String(format: descriptionFormat, String(describing: error))
            }
            
            let appError = AppError(error: error, localizedDescription: description)
            content = .appUnavailable(appError)
        }
    }
}
