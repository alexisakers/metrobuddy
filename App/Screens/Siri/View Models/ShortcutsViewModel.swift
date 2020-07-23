import Intents
import MetroKit


class ShorcutsViewModel: ObservableObject {
    enum Content {
        case loading
        case loaded(AssistantActionListItem)
    }

    @Published var items: [AssistantActionListItem] = []

    init() {
        items = makeListItems(for: [])
        reload()
    }

    func reload() {
        INVoiceShortcutCenter.shared.getAllVoiceShortcuts { shortcuts, error in
            guard let shortcuts = shortcuts else {
                print("No")
                #warning("TODO Alexis: Handle errors")
                return
            }

            DispatchQueue.main.async {
                self.items = self.makeListItems(for: shortcuts)
            }
        }
    }

    private func makeListItems(for shortcuts: [INVoiceShortcut]) -> [AssistantActionListItem] {
        let shortcutsByAction: [AssistantAction: INVoiceShortcut] = shortcuts.reduce(into: [:]) { list, voiceShortcut in
            guard let action = voiceShortcut.shortcut.action else {
                return
            }

            list[action] = voiceShortcut
        }

        return AssistantAction.allCases.map {
            if let voiceShortcut = shortcutsByAction[$0] {
                return AssistantActionListItem(action: $0, configurationOption: .edit(voiceShortcut))
            } else {
                return AssistantActionListItem(action: $0, configurationOption: .add(INShortcut($0)))
            }
        }
    }
}
