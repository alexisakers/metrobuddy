import SwiftUI
import MetroKit

/// An object that requests haptic feedback from the device.
class Haptics {
    /// Requests a success haptic feedback.
    func success() {
        let feedbackGenerator = UINotificationFeedbackGenerator()
        feedbackGenerator.prepare()
        feedbackGenerator.notificationOccurred(.success)
    }
    
    /// Requests a failure haptic feedback.
    func failure() {
        let feedbackGenerator = UINotificationFeedbackGenerator()
        feedbackGenerator.prepare()
        feedbackGenerator.notificationOccurred(.error)
    }
    
    /// Requests a haptic feedback for the completion of a task.
    func notify(completion: TaskCompletion) {
        switch completion {
        case .success:
            success()
        case .failure:
            failure()
        }
    }

    /// Requests a haptic feedback for an impact between UI components.
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: style)
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
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
