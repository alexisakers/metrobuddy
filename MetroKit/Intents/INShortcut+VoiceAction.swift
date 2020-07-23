import Intents

extension INShortcut {
    public init(_ action: AssistantAction) {
        let intent: INIntent
        switch action {
        case .swipeCard:
            intent = MBYSwipeCardIntent()
        case .checkBalance:
            intent = MBYCheckBalanceIntent()
        }

        intent.suggestedInvocationPhrase = action.title
        self = INShortcut(intent: intent)!
    }

    /// Returns the action associated with the shortcut.
    public var action: AssistantAction? {
        if intent is MBYSwipeCardIntent {
            return .swipeCard
        } else if intent is MBYCheckBalanceIntent {
            return .checkBalance
        } else {
            return nil
        }
    }
}
