import XCTest
import MetroTesting

class ScenarioBasedTestCase<RootPage: AppPage>: XCTestCase {
    /// Creates the root page for the test after configuring and launching the app for the specified scenario.
    func rootPageWithScenario(_ scenario: TestScenario.Type) -> RootPage {
        let app = XCUIApplication(scenario: scenario)
        app.launch()
        return RootPage(app: app)
    }
}
