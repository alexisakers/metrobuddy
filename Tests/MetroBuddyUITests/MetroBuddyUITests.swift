import XCTest
import MetroTesting

class MetroBuddyUITests: XCTestCase {
    var page: MetroCardPage!

    override func tearDown() {
        super.tearDown()
        page = nil
    }

    // MARK: - Actions

    func testUpdateFareAction() {
        configureScenario(ReturningUserTestScenario.self)

        // The initial value is 2.75
        XCTAssertEqual(page.fareValue, "$2.75")
        XCTAssertEqual(page.subtitle, "9 swipes left")

        // Tapping on the alert and cancelling has no effect
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
        XCTAssertEqual(page.subtitle, "8 swipes left")
    }

    func testUpdateBalanceAction() {
        configureScenario(ReturningUserTestScenario.self)

        // The initial value is $25
        XCTAssertEqual(page.balanceValue, "$25.00")
        XCTAssertEqual(page.subtitle, "9 swipes left")

        // Tapping on the alert and cancelling has no effect
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

    // MARK: - Last Swipe

    func testLastSwipeBehavior() {
        configureScenario(OneSwipeLeftTestScenario.self)

        // The initial balance is $2.75
        XCTAssertEqual(page.balanceValue, "$2.75")
        XCTAssertEqual(page.subtitle, "1 swipe left")

        // When swiping the last swipe, the balance and subtitle are updated
        page.tapSwipeButton()
        XCTAssertEqual(page.balanceValue, "$0.00")
        XCTAssertEqual(page.subtitle, "No swipes left")

        // When swiping again, we show the toast
        page.tapSwipeButton()
        XCTAssertEqual(page.balanceValue, "$0.00")
        XCTAssertEqual(page.subtitle, "No swipes left")
        XCTAssertEqual(page.toastText, "INSUFFICIENT FARE")
    }

    func configureScenario(_ scenario: TestScenario.Type) {
        let app = XCUIApplication(scenario: scenario)
        app.launch()
        page = MetroCardPage(app: app)
    }
}
