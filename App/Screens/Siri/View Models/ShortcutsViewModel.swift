import Intents
import MetroKit


class ShorcutsViewModel: ObservableObject {
    enum State {
        case loading
        case loaded([AssistantActionListItem])
        case failure(NSError)
    }

    @Published var state: State = .loading

    init() {
        reload()
    }

    func reload() {
        INVoiceShortcutCenter.shared.getAllVoiceShortcuts { shortcuts, error in
            if let error = error {
                return self.setState(.failure(error as NSError))
            }

            let items = self.makeListItems(for: shortcuts ?? [])
            self.setState(.loaded(items))
        }
    }

    private func setState(_ state: State) {
        DispatchQueue.main.async {
            self.state = state
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
