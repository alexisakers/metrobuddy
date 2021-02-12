import XCTest

/// An page-object that interacts with the history screen.
final class HistoryPage: AppPage {
    var title: String {
        app.staticTexts["History"].label
    }

    var hasEmptyTipView: Bool {
        app.staticTexts["empty-history-tip"].exists
    }
}
