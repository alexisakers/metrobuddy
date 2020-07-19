import XCTest
import MetroTesting

extension XCUIApplication {
    /// Creates a `XCUIApplication` that launches the app using the specified scenario.
    /// This enables us to configure the data used when the app launches without using Core Data.
    /// - parameter scenario: The type of the scenario you want to run the test with.
    convenience init(scenario: TestScenario.Type) {
        self.init()
        launchArguments = [
            "-DisableAnimations",
            "-\(MetroTesting.EnvironmentKeys.scenarioName)", NSStringFromClass(scenario)
        ]
    }
}
