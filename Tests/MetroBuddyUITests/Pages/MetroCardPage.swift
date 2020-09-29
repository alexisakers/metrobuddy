import XCTest

/// An page-object that interacts with the main Metro Card screen.
class MetroCardPage: AppPage {
    private let subtitleID = "subtitle"
    private let cardID = "card"
    private let swipeButtonID = "swipe-button"
    private let balanceButtonID = "balance-button"
    private let fareButtonID = "fare-button"
    private let expirationButtonID = "expiration-button"
    private let cardNumberButtonID = "card-number-button"
    private let tipTitleID = "tip-title"
    private let tipMessageID = "tip-message"
    private let shortcutsButtonID = "shortcuts-button"

    // MARK: - State

    var tipTitle: XCUIElement {
        app.staticTexts[tipTitleID]
    }

    var tipMessage: XCUIElement {
        app.staticTexts[tipMessageID]
    }

    var subtitle: String {
        app.staticTexts[subtitleID].label
    }

    var balanceValue: String {
        app.buttons[cardID].value as! String
    }

    var swipeButton: XCUIElement {
        app.buttons[swipeButtonID]
    }

    var fareValue: String {
        app.buttons[fareButtonID].value as! String
    }

    var serialNumberValue: String {
        app.buttons[cardNumberButtonID].value as! String
    }

    var expirationDateValue: String {
        app.buttons[expirationButtonID].value as! String
    }

    // MARK: - Actions

    func performSwipe() {
        let card = app.buttons[cardID]
        let start = card.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0))
        let end = card.coordinate(withNormalizedOffset: CGVector(dx: -0.5, dy: 0))
        start.press(forDuration: 0, thenDragTo: end)
    }

    func tapSwipeButton() {
        app.buttons[swipeButtonID].tap()
        sleep(1)
    }

    func tapCard() -> TextFieldAlertPage {
        app.buttons[cardID].tap()
        return TextFieldAlertPage(app: app)
    }

    func tapBalanceButton() -> TextFieldAlertPage {
        app.buttons[balanceButtonID].tap()
        return TextFieldAlertPage(app: app)
    }

    func tapFareButton() -> TextFieldAlertPage {
        app.buttons[fareButtonID].tap()
        return TextFieldAlertPage(app: app)
    }

    func tapExpirationButton() -> ExpirationDatePickerPage {
        app.buttons[expirationButtonID].tap()
        sleep(1)
        return ExpirationDatePickerPage(app: app)
    }

    func tapCardNumberButton() -> TextFieldAlertPage {
        app.buttons[cardNumberButtonID].tap()
        return TextFieldAlertPage(app: app)
    }

    func tapShortcutsButton() -> ShortcutsPage {
        app.buttons[shortcutsButtonID].tap()
        return ShortcutsPage(app: app)
    }
}
