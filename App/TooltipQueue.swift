import SwiftUI
import Combine

/// An
class ToastQueue: NSObject, ObservableObject {
    @Published var tooltipText: String? = nil
    
    func addTooltip(_ text: String) {
        NSObject.cancelPreviousPerformRequests(
            withTarget: self,
            selector: #selector(dismissTooltip),
            object: nil
        )
        
        withAnimation {
            tooltipText = text
        }
    
        perform(#selector(dismissTooltip), with: nil, afterDelay: 2)
    }
    
    @objc private func dismissTooltip() {
        withAnimation {
            self.tooltipText = nil
        }
    }
}
