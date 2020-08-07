import XCTest
import MetroTesting

class MetroBuddyUITests: ScenarioBasedTestCase<MetroCardPage> {
    // MARK: - Initial State
    func testThatItDisplaysCardAttributes() {
        let page = rootPageWithScenario(ExistingCardAttributesTestScenario.self)
        XCTAssertEqual(page.fareValue, "$2.75")
        XCTAssertEqual(page.balanceValue, "$25.00")
        XCTAssertEqual(page.serialNumberValue, "0123456789")
        XCTAssertEqual(page.expirationDateValue, "Mar 20, 2020")
    }

    // MARK: - Actions
    func testUpdateFareAction() {
        let page = rootPageWithScenario(ReturningUserTestScenario.self)

        // The initial value is 2.75
        XCTAssertEqual(page.fareValue, "$2.75")
        XCTAssertEqual(page.subtitle, "9 rides left")

        // Tapping on the button and cancelling has no effect
        var alert = page.tapFareButton()
        XCTAssertFalse(alert.saveButton.isEnabled)
        alert.tapCancel()
        XCTAssertEqual(page.fareValue, "$2.75")

        // If you enter invalid text, the save button is disabled
        alert = page.tapFareButton()
        alert.enterText("Not a number :(")
        XCTAssertFalse(alert.saveButton.isEnabled)
        alert.tapCancel()
        XCTAssertEqual(page.fareValue, "$2.75")

        // If you enter a valid value, the save button can be tapped and the value is updated
        alert = page.tapFareButton()
        alert.enterText("3")
        alert.tapSave()
        XCTAssertEqual(page.fareValue, "$3.00")

        // The number of remaining swipes is updated
        XCTAssertEqual(page.subtitle, "8 rides left")
    }

    func testUpdateBalanceAction() {
        let page = rootPageWithScenario(ReturningUserTestScenario.self)

        // The initial value is $25
        XCTAssertEqual(page.balanceValue, "$25.00")
        XCTAssertEqual(page.subtitle, "9 rides left")

        // Tapping on the button and cancelling has no effect
        var alert = page.tapBalanceButton()
        XCTAssertFalse(alert.saveButton.isEnabled)
        alert.tapCancel()
        XCTAssertEqual(page.balanceValue, "$25.00")

        // If you enter invalid text, the save button is disabled
        alert = page.tapBalanceButton()
        alert.enterText("Not a number :(")
        XCTAssertFalse(alert.saveButton.isEnabled)
        alert.tapCancel()
        XCTAssertEqual(page.balanceValue, "$25.00")

        // If you enter a valid value, the save button can be tapped and the value is updated
        alert = page.tapBalanceButton()
        alert.enterText("5.25")
        alert.tapSave()
        XCTAssertEqual(page.balanceValue, "$5.25")

        // The number of remaining swipes is updated
        XCTAssertEqual(page.subtitle, "1 swipe left")
    }

    func testSerialNumberAction() {
        let page = rootPageWithScenario(ReturningUserTestScenario.self)

        // Tapping on the button and cancelling has no effect
        var alert = page.tapCardNumberButton()
        XCTAssertFalse(alert.saveButton.isEnabled)
        alert.tapCancel()
        XCTAssertEqual(page.serialNumberValue, "Add")

        // If you enter a valid value, the save button can be tapped and the value is updated
        alert = page.tapCardNumberButton()
        alert.enterText("0987654321")
        alert.tapSave()
        XCTAssertEqual(page.serialNumberValue, "0987654321")
    }

    func testExpirationDateAction() {
        let page = rootPageWithScenario(ReturningUserTestScenario.self)

        // Tapping on the button and cancelling has no effect
        var alert = page.tapExpirationButton()
        alert.tapCloseButton()
        XCTAssertFalse(alert.removeDateButton.exists)
        XCTAssertEqual(page.expirationDateValue, "Add")

        // Seleting a date hides the alert and updates the text
        alert = page.tapExpirationButton()
        XCTAssertFalse(alert.removeDateButton.exists)

        alert.selectDate(year: 2030, month: 3, day: 20)
        alert.tapSaveButton()
        XCTAssertEqual(page.expirationDateValue, "Mar 20, 2030")

        // Removing the expiration updates the value
        alert = page.tapExpirationButton()
        XCTAssertTrue(alert.removeDateButton.exists)
        alert.tapRemoveDateButton()
        XCTAssertEqual(page.expirationDateValue, "Add")
    }

    // MARK: - Last Swipe

    func testLastSwipeBehavior() {
        let page = rootPageWithScenario(OneSwipeLeftTestScenario.self)

        // The initial balance is $2.75
        XCTAssertEqual(page.balanceValue, "$2.75")
        XCTAssertEqual(page.subtitle, "1 swipe left")

        // When swiping the last swipe, the balance and subtitle are updated
        page.tapSwipeButton()
        XCTAssertEqual(page.balanceValue, "$0.00")
        XCTAssertEqual(page.subtitle, "No rides left")

        // When swiping again, we show the toast
        page.tapSwipeButton()
        XCTAssertEqual(page.balanceValue, "$0.00")
        XCTAssertEqual(page.subtitle, "No rides left")
        XCTAssertEqual(page.toastText, "INSUFFICIENT FARE")
    }
}
