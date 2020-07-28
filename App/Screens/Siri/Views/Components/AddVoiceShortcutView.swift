import IntentsUI
import SwiftUI
import MetroKit

/// A view that allows the user to create a voice shortcut, by wrapping `INUIAddVoiceShortcutViewController`.
struct AddVoiceShortcutView: UIViewControllerRepresentable {
    class Coordinator: NSObject, INUIAddVoiceShortcutViewControllerDelegate {
        let dismiss: (ErrorMessage?) -> Void

        init(dismiss: @escaping (ErrorMessage?) -> Void) {
            self.dismiss = dismiss
        }

        func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
            dismiss(nil)
        }

        func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController, didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?) {
            let errorMessage = error.map {
                ErrorMessage(
                    title: NSLocalizedString("Cannot Add Shortcut", comment: ""),
                    error: $0
                )
            }

            dismiss(errorMessage)
        }
    }

    let shortcut: INShortcut
    let dismiss: (ErrorMessage?) -> Void

    // MARK: - UIViewControllerRepresentable

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
