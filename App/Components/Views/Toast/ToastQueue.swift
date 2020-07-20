import SwiftUI
import Combine

#if DEBUG
import MetroTesting
#endif

/// An object that dynamically manages the displaying and hiding of toasts.
class ToastQueue: NSObject, ObservableObject {
    /// The text of the toast. If `nil`, the toast should be hidden.
    @Published var toastText: String? = nil

    /// Whether to delay dismissal.
    var delayDismissal: Bool {
        #if DEBUG
        return UserDefaults.standard.bool(forKey: TestLaunchKeys.delayToastDismissal)
        #else
        return false
        #endif
    }
    
    /// Displays the given toast, and hides it after 2 seconds, unless another toast was queued.
    /// - parameter text: The text of the toast to display.
    /// - note: Subscribe to the `toastText` publisher to receive the latest toast.
    func displayToast(_ text: String) {
        NSObject.cancelPreviousPerformRequests(
            withTarget: self,
            selector: #selector(dismissTooltip),
            object: nil
        )

        withAnimation(Animation.spring().speed(2)) {
            toastText = text
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UIAccessibility.post(notification: .announcement, argument: text)
        }

        perform(#selector(dismissTooltip), with: nil, afterDelay: delayDismissal ? 5 : 2)
    }
    
    @objc private func dismissTooltip() {
        withAnimation(Animation.spring().speed(2)) {
            toastText = nil
        }
    }
}
