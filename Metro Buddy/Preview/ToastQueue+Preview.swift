import Foundation

#if DEBUG
class PreviewToastQueue: ToastQueue {
    init(overrideValue: String?) {
        super.init()
        self.toastText = overrideValue
    }
    
    override func displayToast(_ text: String) {
        // no-op
    }
}
#endif
