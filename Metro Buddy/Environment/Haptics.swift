import SwiftUI

/// An object that requests haptic feedback from the device.
class Haptics {
    /// Requests a failure haptic feedback.
    func failure() {
        let feedbackGenerator = UINotificationFeedbackGenerator()
        feedbackGenerator.prepare()
        feedbackGenerator.notificationOccurred(.error)
    }
    
    /// Requests a success haptic feedback.
    func success() {
        let feedbackGenerator = UINotificationFeedbackGenerator()
        feedbackGenerator.prepare()
        feedbackGenerator.notificationOccurred(.success)
    }
}

// MARK: - Environment

private struct HapticsKey: EnvironmentKey {
    static var defaultValue: Haptics = Haptics()
}

extension EnvironmentValues {
    /// The object that requests haptic feedback from the device.
    var haptics: Haptics {
        get { self[HapticsKey.self] }
        set { self[HapticsKey.self] = newValue }
    }
}
