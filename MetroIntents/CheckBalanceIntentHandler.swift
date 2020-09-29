import Intents
import MetroKit

/// An object that handles the `MBYCheckBalanceIntent` by fetching the current balance.
class CheckBalanceIntentHandler: NSObject, MBYCheckBalanceIntentHandling {
    let dataStore: MetroCardDataStore
    
    init(dataStore: MetroCardDataStore) {
        self.dataStore = dataStore
    }

    func handle(intent: MBYCheckBalanceIntent, completion: @escaping (MBYCheckBalanceIntentResponse) -> Void) {
        do {
            let card = try dataStore.currentCard()
            let remainingRidesFormat = String.LocalizationFormats.remainingRides
            let formattedRemainingRides = String.localizedStringWithFormat(remainingRidesFormat, card.remainingRides)

            let response = MBYCheckBalanceIntentResponse(code: .success, userActivity: nil)
            response.balance = INCurrencyAmount(amount: card.balance as NSDecimalNumber, currencyCode: "USD")
            response.formattedRideCount = formattedRemainingRides
            completion(response)
        } catch {
            let response = MBYCheckBalanceIntentResponse(code: .failure, userActivity: nil)
            completion(response)
        }
    }
}
