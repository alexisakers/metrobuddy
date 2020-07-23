import IntentsUI
import SwiftUI

/// A view that allows the user to create a voice shortcut, by wrapping `INUIAddVoiceShortcutViewController`.
struct AddVoiceShortcutView: UIViewControllerRepresentable {
    class Coordinator: NSObject, INUIAddVoiceShortcutViewControllerDelegate {
        let dismiss: () -> Void

        init(dismiss: @escaping () -> Void) {
            self.dismiss = dismiss
        }

        func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
            dismiss()
        }

        func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController, didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?) {
            #warning("TODO Alexis: Handle error")
            dismiss()
        }
    }

    let shortcut: INShortcut
    let dismiss: () -> Void

    func makeCoordinator() -> Coordinator {
        return Coordinator(dismiss: dismiss)
    }

    func makeUIViewController(context: Context) -> INUIAddVoiceShortcutViewController {
        return INUIAddVoiceShortcutViewController(shortcut: shortcut)
    }

    func updateUIViewController(_ uiViewController: INUIAddVoiceShortcutViewController, context: Context) {
        uiViewController.delegate = context.coordinator
    }
}
