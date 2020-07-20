import XCTest
import MetroTesting

final class SnapshotsTestCase: XCTestCase {
    var page: MetroCardPage!

    override func setUp() {
        super.setUp()
        let app = XCUIApplication(scenario: ExistingCardAttributesTestScenario.self)
        app.launchArguments += [
            "-" + TestLaunchKeys.delayToastDismissal, "1"
        ]

        setupSnapshot(app)
        page = MetroCardPage(app: app)
        app.launch()
    }

    override func tearDown() {
        super.tearDown()
        page = nil
    }

    func testSnapshots() {
        // 1) Keep track of your balance
        snapshot("01Card")

        // 2) Add extra details
        let dateAlert = page.tapExpirationButton()
        snapshot("02ExtraDetails")
        dateAlert.tapCloseButton()

        // 3) Customize your fare
        let fareAlert = page.tapFareButton()
        snapshot("03CustomFare")
        fareAlert.tapCancel()

        // 4) Know when it's time to refill
        let balanceAlert = page.tapBalanceButton()
        balanceAlert.enterText("2.25")
        balanceAlert.tapSave()

        page.tapSwipeButton()
        sleep(1)
        snapshot("04NoSwipesLeft")
    }
}
