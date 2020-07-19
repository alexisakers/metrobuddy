import XCTest

/// A page object for the expiration date picker.
final class ExpirationDatePickerPage: AppPage {
    private let closeButtonID = "close-button"
    private let saveButtonID = "save-button"
    private let removeDateButtonID = "remove-date-button"

    var removeDateButton: XCUIElement {
        app.buttons[removeDateButtonID]
    }

    func selectDate(year: Int, month: Int, day: Int) {
        let pickers = app.pickers.children(matching: .pickerWheel).allElementsBoundByIndex
        pickers[0].adjust(toPickerWheelValue: Calendar.current.monthSymbols[month - 1])
        pickers[1].adjust(toPickerWheelValue: String(day))
        pickers[2].adjust(toPickerWheelValue: String(year))
    }

    func tapCloseButton() {
        app.buttons[closeButtonID].tap()
        sleep(1)
    }

    func tapSaveButton() {
        app.buttons[saveButtonID].tap()
        sleep(1)
    }

    func tapRemoveDateButton() {
        app.buttons[removeDateButtonID].tap()
        sleep(1)
    }
}
