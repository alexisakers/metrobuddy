import Intents
import os.log

/// A list of donations .
public enum AssistantActionDonation {
    /// The user successfully swiped their card, which resulted in the specified balance.
    case swipeCard(balance: Decimal)

    /// The user checked their balance.
    case checkBalance(balance: Decimal)
}

/// The namespace to donate assistant actions.
public enum AssistantActionDonationCenter {
    /// Donates an action to the system to enable better suggestions.
    /// - parameter action: The action to donate.
    public static func donate(action: AssistantActionDonation) {
        switch action {
        case .swipeCard(let balance):
            let intent = MBYSwipeCardIntent()
            let response = MBYSwipeCardIntentResponse(code: .success, userActivity: nil)
            response.balance = INCurrencyAmount(amount: balance as NSDecimalNumber, currencyCode: "USD")

            let interation = INInteraction(intent: intent, response: response)
            interation.donate {
                logDonationCompletion($0, intent: MBYSwipeCardIntent.self)
            }

        case .checkBalance(let balance):
            let intent = MBYCheckBalanceIntent()
            let response = MBYCheckBalanceIntentResponse(code: .success, userActivity: nil)
            response.balance = INCurrencyAmount(amount: balance as NSDecimalNumber, currencyCode: "USD")

            let interation = INInteraction(intent: intent, response: response)
            interation.donate {
                logDonationCompletion($0, intent: MBYCheckBalanceIntent.self)
            }
        }
    }

    private static func logDonationCompletion(_ error: Error?, intent: AnyClass) {
        guard let error = error else {
            return os_log("Donated interaction for %@", NSStringFromClass(intent))
        }

        os_log("Cannot donate intent due to error: %@", error as NSError)
    }
}
