import Foundation

/// A namespace containing the flags that are passed in the launch arguments .
public enum TestLaunchKeys {
    /// Whether animations are allowed, as a `Bool`.
    public static let disableAnimations = "DisableAnimations"

    /// The name of the scenario to use, as a `String`.
    public static let scenarioName = "MetroTestingScenarioName"

    /// Whether to keep toasts displayed longer, as a `Bool`.
    public static let delayToastDismissal = "DelayToastDismissal"
}
