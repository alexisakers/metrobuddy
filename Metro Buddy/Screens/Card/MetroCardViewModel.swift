import Combine
import Foundation
import MetroKit
import SwiftUI
import CombineExt

enum MetroCardBalanceError: Error {
    case insufficientFunds
    case cannotSave(Error)
}

enum TaskCompletion {
    case success
    case failure
}

class MetroCardViewModel: ObservableObject {
    private let dataStore: MetroCardDataStore
    private let updateSubject = PassthroughSubject<MetroCardUpdate, Never>()
    private let swipeSubject = PassthroughSubject<Void, Never>()
    private var tasks: Set<AnyCancellable> = []

    @Published var data: MetroCardData
    @Published var showOnboarding: Bool = false
    @Published var hasError: Bool = false
    let tooltip: AnyPublisher<String, Never>
    let completedTasks: AnyPublisher<TaskCompletion, Never>

    @Published var error: ErrorMessage?
    var errorBinding: Binding<ErrorMessage?> {
        Binding(get: { self.error }, set: { self.error = $0 })
    }
    
    static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.currencyCode = "USD"
        formatter.numberStyle = .currency
        return formatter
    }()
    
    static let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        return formatter
    }()
    
    static let inputNumberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        return formatter
    }()
    
    public init(card: ObjectReference<MetroCard>, dataStore: MetroCardDataStore, preferences: Preferences) {
        self.dataStore = dataStore
                
        let cardPublisher = dataStore
            .publisher(for: card)
            .share(replay: 1)
        
        func makeData(for card: ObjectReference<MetroCard>) -> MetroCardData {
            let formattedDate = card.expirationDate.map(Self.shortDateFormatter.string(from:))
            
            let remainingSwipes = card.balance
                .quotientAndRemainer(dividingBy: card.fare)
                .quotient
            
            let formattedRemainingSwipesFormat = NSLocalizedString("remaining_swipes", comment: "")
            
            return MetroCardData(
                source: card,
                formattedBalance: Self.currencyFormatter.string(from: card.balance as NSDecimalNumber)!,
                formattedExpirationDate: formattedDate,
                formattedSerialNumber: card.serialNumber,
                formattedFare: Self.currencyFormatter.string(from: card.fare as NSDecimalNumber)!,
                formattedRemainingSwipes: .localizedStringWithFormat(formattedRemainingSwipesFormat, remainingSwipes)
            )
        }
        
        self.data = makeData(for: card)
        
        let updateElements = updateSubject
            .withLatestFrom(cardPublisher) { ($0, $1) }
            .receive(on: DispatchQueue.main)
            .flatMap { update, card in
                dataStore.applyUpdates([update], to: card)
                    .handleEvents(receiveCompletion: {
                        if case .finished = $0 {
                            if case .balance = update {
                                preferences.setValue(true, forKey: UserDidOnboardPreferenceKey.self)
                            }
                        }
                    })
                    .materialize()
            }
        
        let swipeElements = swipeSubject
            .withLatestFrom(cardPublisher) { ($0, $1) }
            .receive(on: DispatchQueue.main)
            .flatMap { _, card -> Publishers.Materialize<AnyPublisher<Void, Error>> in
                guard card.balance >= card.fare else {
                    return Fail<Void, Error>(error: MetroCardBalanceError.insufficientFunds as Error)
                        .eraseToAnyPublisher()
                        .materialize()
                }
                
                let update = MetroCardUpdate.balance(card.balance - card.fare)
                return dataStore.applyUpdates([update], to: card)
                    .eraseToAnyPublisher()
                    .materialize()
            }
        
        let taskEvents = updateElements
            .merge(with: swipeElements)
            .share(replay: 1)
        
        completedTasks = taskEvents
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
                
        tooltip = taskEvents
            .compactMap {
                guard case .failure(MetroCardBalanceError.insufficientFunds) = $0 else {
                    return nil
                }
                
                return NSLocalizedString("Insufficient Fare", comment: "")
                    .localizedUppercase
            }.eraseToAnyPublisher()
        
        cardPublisher
            .map(makeData)
            .assign(to: \.data, on: self)
            .store(in: &tasks)
        
        cardPublisher
            .map { card in
                let userDidOnboard = preferences
                    .value(forKey: UserDidOnboardPreferenceKey.self)
                return !userDidOnboard && card.balance == 0
            }.assign(to: \.showOnboarding, on: self)
            .store(in: &tasks)
    }
    
    func perform(update: MetroCardUpdate) {
        updateSubject.send(update)
    }
    
    func saveBalance(_ input: String?) {
        guard let update = parseInput(input, to: MetroCardUpdate.balance) else {
            return
        }

        updateSubject.send(update)
    }
    
    func saveFare(_ input: String?) {
        guard let update = parseInput(input, to: MetroCardUpdate.fare) else {
            return
        }
        
        updateSubject.send(update)
    }
    
    func swipe() {
        swipeSubject.send(())
    }
    
    func saveSerialNumber(_ input: String?) {
        guard let input = input else {
            return
        }
        
        let updatedValue = input.isEmpty ? nil : input
        updateSubject.send(.serialNumber(updatedValue))
    }
    
    private func parseInput(_ input: String?, to update: (Decimal) -> MetroCardUpdate) -> MetroCardUpdate? {
        guard let number = input.flatMap(Self.inputNumberFormatter.number) as? Decimal else {
            return nil
        }

        return update(number)
    }
}
