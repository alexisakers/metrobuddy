import XCTest

class ShortcutsPage: AppPage {
    private let closeButtonID = "close-button"

    func close() {
        app.buttons[closeButtonID].tap()
    }
}
