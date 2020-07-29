import Intents

/// A protocol for intent responses that provide a balance.
public protocol BalanceProvidingIntentResponse {
    var balance: INCurrencyAmount? { get }
}

extension MBYSwipeCardIntentResponse: BalanceProvidingIntentResponse {}
extension MBYCheckBalanceIntentResponse: BalanceProvidingIntentResponse {}
