import Combine
import Intents
import MetroKit

/// An object that handles the `MBYSwipeCardIntent` by attempting to update the card details.
class SwipeMetroCardIntentHandler: NSObject, MBYSwipeCardIntentHandling {
    enum Result {
        case insufficientFunds(Decimal)
        case success(Decimal)
        case failure(Error)
    }

    let dataStore: MetroCardDataStore
    private var tasks: Set<AnyCancellable> = []

    init(dataStore: MetroCardDataStore) {
        self.dataStore = dataStore
    }

    func handle(intent: MBYSwipeCardIntent, completion: @escaping (MBYSwipeCardIntentResponse) -> Void) {
        _handle(intent: intent) { result in
            let response = self.makeResponse(for: result)
            completion(response)
        }
    }

    private func _handle(intent: MBYSwipeCardIntent, completion: @escaping (Result) -> Void) {
        do {
            let currentCard = try dataStore.currentCard()
            guard currentCard.balance >= currentCard.fare else {
                return completion(.insufficientFunds(currentCard.balance))
            }

            let newBalance = currentCard.balance - currentCard.fare
            dataStore.applyUpdates([.balance(newBalance)], to: currentCard)
                .sink(receiveCompletion: {
                    if case let .failure(error) = $0 {
                        return completion(.failure(error))
                    } else {
                        return completion(.success(newBalance))
                    }
                }, receiveValue: { _ in })
                .store(in: &tasks)

        } catch {
            return completion(.failure(error))
        }
    }

    private func makeResponse(for result: Result) -> MBYSwipeCardIntentResponse {
        switch result {
        case .insufficientFunds(let balance):
            let response = MBYSwipeCardIntentResponse(code: .insufficientFunds, userActivity: nil)
            response.balance = INCurrencyAmount(amount: balance as NSDecimalNumber, currencyCode: "USD")
            return response

        case .failure:
            let response = MBYSwipeCardIntentResponse(code: .failure, userActivity: nil)
            return response

        case .success(let balance):
            let response = MBYSwipeCardIntentResponse(code: .success, userActivity: nil)
            response.balance = INCurrencyAmount(amount: balance as NSDecimalNumber, currencyCode: "USD")
            return response
        }
    }
}
