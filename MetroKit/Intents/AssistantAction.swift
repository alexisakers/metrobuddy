import Foundation

/// A list of Siri shortcuts supported by the app.
public enum AssistantAction: Int, CaseIterable {
    case swipeCard = 0
    case checkBalance = 1

    /// The title of the shortcut.
    public var title: String {
        switch self {
        case .swipeCard:
            return NSLocalizedString("Swipe Card", comment: "The name of the shortcut that asks Siri to swipe the card")
        case .checkBalance:
            return NSLocalizedString("Check my MetroCard Balance", comment: "The name of the shortcut that asks Siri for the current card balance.")
        }
    }

    /// The description of the shortcut to use when the user hasn't added a phrase for it yet.
    public var localizedDescription: String {
        switch self {
        case .swipeCard:
            return NSLocalizedString("Ask Siri to swipe your card and update your balance.", comment: "")
        case .checkBalance:
            return NSLocalizedString("Ask Siri to check how much money you have left on your MetroCard.", comment: "")
        }
    }

    /// The description of the shortcut that includes the user-selected phrase added to Siri.
    public func localizedDescription(withPhrase phrase: String) -> String{
        let format: String
        switch self {
        case .swipeCard:
            format = NSLocalizedString("Tell Siri “%@” to swipe your card and update your balance.", comment: "The first argument is the phrase the user selected for the shortcut.")
        case .checkBalance:
            format = NSLocalizedString("Tell Siri “%@” to check how much money you have left on your MetroCard.", comment: "The first argument is the phrase the user selected for the shortcut.")
        }

        return String(format: format, phrase)
    }
}
