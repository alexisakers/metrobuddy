import IntentsUI
import SwiftUI
import MetroKit

/// A view that enables editing an existing voice shortcut by wrapping `INUIEditVoiceShortcutViewController`.
struct EditVoiceShortcutView: UIViewControllerRepresentable {
    class Coordinator: NSObject, INUIEditVoiceShortcutViewControllerDelegate {
        let dismiss: (ErrorMessage?) -> Void

        init(dismiss: @escaping (ErrorMessage?) -> Void) {
            self.dismiss = dismiss
        }

        func editVoiceShortcutViewControllerDidCancel(_ controller: INUIEditVoiceShortcutViewController) {
            dismiss(nil)
        }

        func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didUpdate voiceShortcut: INVoiceShortcut?, error: Error?) {
            let errorMessage: ErrorMessage? = error.map {
                ErrorMessage(
                    title: NSLocalizedString("Cannot Edit Shortcut", comment: ""),
                    error: $0
                )
            }

            dismiss(errorMessage)
        }

        func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didDeleteVoiceShortcutWithIdentifier deletedVoiceShortcutIdentifier: UUID) {
            dismiss(nil)
        }
    }

    // MARK: - UIViewControllerRepresentable

    let shortcut: INVoiceShortcut
    let dismiss: (ErrorMessage?) -> Void

    func makeCoordinator() -> Coordinator {
        return Coordinator(dismiss: dismiss)
    }

    func makeUIViewController(context: Context) -> INUIEditVoiceShortcutViewController {
        return INUIEditVoiceShortcutViewController(voiceShortcut: shortcut)
    }

    func updateUIViewController(_ uiViewController: INUIEditVoiceShortcutViewController, context: Context) {
        uiViewController.delegate = context.coordinator
    }
}

