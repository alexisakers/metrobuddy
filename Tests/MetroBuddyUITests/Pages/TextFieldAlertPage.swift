import XCTest

/// A page object that interacts with a text field alert.
final class TextFieldAlertPage: AppPage {
    var saveButton: XCUIElement {
        app.buttons["alert-save-button"]
    }

    // MARK: - Actions

    func tapCancel() {
        app.buttons["alert-cancel-button"].tap()
    }

    func tapSave() {
        app.buttons["alert-save-button"].tap()
    }

    func enterText(_ text: String) {
        app.textFields["alert-text-field"].typeText(text)
    }
}
