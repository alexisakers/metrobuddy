import Combine
import CombineExt
import Foundation
import Intents
import SwiftUI
import MetroKit

/// An object responsible for computing the, and which side effects to display when the data changes.
class MetroCardViewModel: ObservableObject {
    private enum MetroCardBalanceError: Error {
        case insufficientFunds(Decimal)
    }
    
    // MARK: - Properties
    
    private let dataStore: MetroCardDataStore
    private let updateSubject = PassthroughSubject<MetroCardUpdate, Never>()
    private let swipeSubject = PassthroughSubject<Void, Never>()
    private var tasks: Set<AnyCancellable> = []

    // MARK: - Outputs
    
    /// The current card data to display to the user.
    @Published var data: MetroCardData
    
    /// Emits a user-friendly message when an error occurs.
    @Published var errorMessage: ErrorMessage?
    
    /// Emits toasts to display to the user.
    let toast: AnyPublisher<String, Never>
    
    /// Emits a value when a task was completed.
    let taskCompletion: AnyPublisher<TaskCompletion, Never>
                
    // MARK: - Initialization
    
    public init(card: ObjectReference<MetroCard>, dataStore: MetroCardDataStore, preferences: UserPreferences) {
        self.dataStore = dataStore
        self.data = Self.makeData(for: card, preferences: preferences)

        let cardPublisher = dataStore
            .publisher(for: card)
            .share(replay: 1)

        // Set Up Update Publishers
        let updateElements = updateSubject
            .withLatestFrom(cardPublisher) { ($0, $1) }
            .flatMap { update, card in
                dataStore.applyUpdates([update], to: card)
                    .receive(on: DispatchQueue.main)
                    .handleEvents(receiveCompletion: {
                        if case .finished = $0, case .balance = update {
                            preferences.setValue(true, forKey: UserDidOnboardPreferenceKey.self)
                        }
                    })
                    .materialize()
            }
        
        let swipeElements = swipeSubject
            .withLatestFrom(cardPublisher) { ($0, $1) }
            .flatMap { _, card -> Publishers.Materialize<AnyPublisher<Void, Error>> in
                guard card.balance >= card.fare else {
                    return Fail<Void, Error>(error: MetroCardBalanceError.insufficientFunds(card.balance) as Error)
                        .eraseToAnyPublisher()
                        .materialize()
                }

                let newBalance = card.balance - card.fare
                let update = MetroCardUpdate.balance(card.balance - card.fare)
                return dataStore.applyUpdates([update], to: card)
                    .handleEvents(receiveCompletion: {
                        Self.donateSwipeInteraction(requestedBalance: newBalance, completion: $0)
                    })
                    .receive(on: DispatchQueue.main)
                    .eraseToAnyPublisher()
                    .materialize()
            }

        // Set Up Completion/Failure Publishers
        let taskEvents = updateElements
            .merge(with: swipeElements)
            .share(replay: 1)
        
        taskCompletion = taskEvents
            .compactMap { event in
                switch event {
                case .finished:
                    return .success
                case .failure:
                    return .failure
                case .value:
                    return nil
                }
            }.eraseToAnyPublisher()
                
        toast = taskEvents
            .compactMap {
                guard case .failure(MetroCardBalanceError.insufficientFunds) = $0 else {
                    return nil
                }
                
                return NSLocalizedString("Insufficient Fare", comment: "").localizedUppercase
            }.eraseToAnyPublisher()
        
        taskEvents
            .compactMap { event -> ErrorMessage? in
                switch event {
                case .failure(MetroCardBalanceError.insufficientFunds):
                    return nil
                case .failure(let error):
                    return ErrorMessage(title: "Cannot Save Changes", error: error)
                default:
                    return nil
                }
            }.assign(to: \.errorMessage, on: self)
            .store(in: &tasks)
        
        // Process and Display Card Changes
        cardPublisher
            .receive(on: DispatchQueue.global(qos: .userInteractive))
            .map { Self.makeData(for: $0, preferences: preferences) }
            .receive(on: DispatchQueue.main)
            .assign(to: \.data, on: self)
            .store(in: &tasks)
    }
    
    // MARK: - Inputs
        
    /// Validates the input for the balance field. Returns `true` if the input is a valid number.
    func validateBalance(_ input: String?) -> Bool {
        if case .balance = parseInput(input, to: MetroCardUpdate.balance) {
            return true
        } else {
            return false
        }
    }
    
    /// Saves the new validated balance.
    func saveBalance(_ input: String?) {
        guard let update = parseInput(input, to: MetroCardUpdate.balance) else {
            return
        }

        updateSubject.send(update)
    }
    
    /// Validates the input for the fare field. Returns `true` if the input is a valid number, and if the fare is greater than 0.
    func validateFare(_ input: String?) -> Bool {
        guard case let .fare(number) = parseInput(input, to: MetroCardUpdate.fare) else {
            return false
        }
        
        return number > 0
    }
    
    /// Saves the new validated fare.
    func saveFare(_ input: String?) {
        guard let update = parseInput(input, to: MetroCardUpdate.fare) else {
            return
        }
        
        updateSubject.send(update)
    }
    
    /// Validates the input for the serial number field. Returns `true` if the input is not empty.
    func validateSerialNumber(_ input: String?) -> Bool {
        guard let input = input else {
            return false
        }

        return !input.isEmpty
    }
    
    /// Saves the new serial number.
    func saveSerialNumber(_ input: String?) {
        guard let input = input else {
            return
        }
        
        let updatedValue = input.isEmpty ? nil : input
        updateSubject.send(.serialNumber(updatedValue))
    }

    /// Saves the new expiration date.
    func saveExpirationDate(_ date: Date?) {
        updateSubject.send(.expirationDate(date))
    }

    /// Records a swipe.
    func recordSwipe() {
        swipeSubject.send(())
    }

    private func parseInput(_ input: String?, to update: (Decimal) -> MetroCardUpdate) -> MetroCardUpdate? {
        guard let number = input.flatMap(Self.inputNumberFormatter.number) as? Decimal else {
            return nil
        }

        return update(number)
    }

    // MARK: - Intents

    private static func donateSwipeInteraction(requestedBalance: Decimal, completion: Subscribers.Completion<Error>) {
        let response: MBYSwipeCardIntentResponse
        switch completion {
        case .finished:
            response = MBYSwipeCardIntentResponse(code: .success, userActivity: nil)
            response.balance = INCurrencyAmount(amount: requestedBalance as NSDecimalNumber, currencyCode: "USD")

        case .failure(let error):
            switch error {
            case MetroCardBalanceError.insufficientFunds(let currentBalance):
                response = MBYSwipeCardIntentResponse(code: .insufficientFunds, userActivity: nil)
                response.balance = INCurrencyAmount(amount: currentBalance as NSDecimalNumber, currencyCode: "USD")

            default:
                response = MBYSwipeCardIntentResponse(code: .failure, userActivity: nil)
            }
        }

        let interaction = INInteraction(intent: MBYSwipeCardIntent(), response: response)
        interaction.donate {
            dump($0)
        }
    }
}

// MARK: - Helpers

extension MetroCardViewModel {
    private static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.currencyCode = "USD"
        formatter.numberStyle = .currency
        return formatter
    }()
    
    private static let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        return formatter
    }()
    
    private static let inputNumberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        return formatter
    }()

    /// Creates a `MetroCardData` object from an underlying card data,
    private static func makeData(for card: ObjectReference<MetroCard>, preferences: UserPreferences) -> MetroCardData {
        let formattedBalance = Self.currencyFormatter
            .string(from: card.balance as NSDecimalNumber)!
        
        let formattedDate = card.expirationDate
            .map(shortDateFormatter.string(from:))
        
        let formattedFare = Self.currencyFormatter
            .string(from: card.fare as NSDecimalNumber)!
        
        let remainingSwipes = card.balance
            .quotientAndRemainer(dividingBy: card.fare)
            .quotient
        
        let formattedRemainingSwipesFormat = NSLocalizedString("remaining_swipes", comment: "")
        let formattedRemainingSwipes = String
            .localizedStringWithFormat(formattedRemainingSwipesFormat, remainingSwipes)
        
        let userDidOnboard = preferences
            .value(forKey: UserDidOnboardPreferenceKey.self)
        
        return MetroCardData(
            isOnboarded: userDidOnboard || card.balance != 0,
            formattedBalance: formattedBalance,
            expirationDate: card.expirationDate,
            formattedExpirationDate: formattedDate,
            formattedSerialNumber: card.serialNumber,
            formattedFare: formattedFare,
            formattedRemainingSwipes: formattedRemainingSwipes
        )
    }
}
