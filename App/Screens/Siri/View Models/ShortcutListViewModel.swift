import Intents
import MetroKit

/// An object that is responsible for calculating the content of the shortcuts view based on the `INVoiceShortcutCenter`'s data.
final class ShortcutListViewModel: ObservableObject {
    /// The possible contents of the view.
    enum Content {
        case loading
        case loaded([ShortcutListItem])
        case failure(ErrorMessage)
    }

    /// The content to display, as a published property.
    @Published var content: Content = .loading

    private let voiceShortcutsCenter: VoiceShortcutsCenter

    /// MARK: - Initialization

    init(voiceShortcutsCenter: VoiceShortcutsCenter) {
        self.voiceShortcutsCenter = voiceShortcutsCenter
        reload()
    }

    // MARK: - Inputs

    func reload() {
        voiceShortcutsCenter.getSavedShortcuts { result in
            switch result {
            case .success(let shortcuts):
                let items = self.makeListItems(for: shortcuts)
                self.updateContent(.loaded(items))

            case .failure(let error):
                let errorMessage = ErrorMessage(
                    title: NSLocalizedString("Cannot load shortcuts", comment: ""),
                    error: error
                )

               return self.updateContent(.failure(errorMessage))
            }
        }
    }

    // MARK: - Helpers

    /// Sets the `content` property on the main thread.
    private func updateContent(_ content: Content) {
        DispatchQueue.main.async {
            self.content = content
        }
    }

    /// Creates the items to display in the list of shortcuts.
    private func makeListItems(for shortcuts: [INVoiceShortcut]) -> [ShortcutListItem] {
        let shortcutsByAction: [AssistantAction: INVoiceShortcut] = shortcuts.reduce(into: [:]) { list, voiceShortcut in
            guard let action = voiceShortcut.shortcut.action else {
                return
            }

            list[action] = voiceShortcut
        }

        return AssistantAction.allCases.map {
            if let voiceShortcut = shortcutsByAction[$0] {
                let accessibilityLabelFormat = NSLocalizedString("Edit '%@' shortcut", comment: "The first parameter is the title of the shortcut.")
                let accessibilityLabel = String(format: accessibilityLabelFormat, $0.title)

                return ShortcutListItem(action: $0, configurationOption: .edit(voiceShortcut), accessibilityLabel: accessibilityLabel)
            } else {
                let accessibilityLabelFormat = NSLocalizedString("Add '%@' shortcut", comment: "The first parameter is the title of the shortcut.")
                let accessibilityLabel = String(format: accessibilityLabelFormat, $0.title)

                return ShortcutListItem(action: $0, configurationOption: .add(INShortcut($0)), accessibilityLabel: accessibilityLabel)
            }
        }
    }
}
