import IntentsUI
import SwiftUI

/// A view that enables editing an existing voice shortcut by wrapping `INUIEditVoiceShortcutViewController`.
struct EditVoiceShortcutView: UIViewControllerRepresentable {
    class Coordinator: NSObject, INUIEditVoiceShortcutViewControllerDelegate {
        let dismiss: () -> Void

        init(dismiss: @escaping () -> Void) {
            self.dismiss = dismiss
        }

        func editVoiceShortcutViewControllerDidCancel(_ controller: INUIEditVoiceShortcutViewController) {
            dismiss()
        }

        func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didUpdate voiceShortcut: INVoiceShortcut?, error: Error?) {
            #warning("TODO Alexis: Handle error")
            dismiss()
        }

        func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didDeleteVoiceShortcutWithIdentifier deletedVoiceShortcutIdentifier: UUID) {
            dismiss()
        }
    }

    // MARK: - UIViewControllerRepresentable

    let shortcut: INVoiceShortcut
    let dismiss: () -> Void

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

