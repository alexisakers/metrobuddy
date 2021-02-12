import XCTest

/// Our UI tests are based on the page-object pattern. This architecture decouples the assertions from the UI automation. The page object
/// (a concrete subclass of this class) is responsible for querying the `XCUIApplication` to find elements, retrieve their labels and values,
/// and perform gestures. When you tap a button that presents a screen, the method on the page object usually returns another page object that enables the tests
/// to interact with the side effect of the button tap.
class AppPage {
    let app: XCUIApplication

    required init(app: XCUIApplication) {
        self.app = app
    }

    /// The text of the global toast.
    var toastText: String {
        app.staticTexts["toast"].label
    }

    func tapMetroCardTab() -> MetroCardPage {
        app.tabBars.buttons["My Card"].tap()
        return MetroCardPage(app: app)
    }

    func tapHistoryTab() -> HistoryPage {
        app.tabBars.buttons["History"].tap()
        return HistoryPage(app: app)
    }
}
