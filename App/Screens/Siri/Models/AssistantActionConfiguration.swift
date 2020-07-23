import Intents

/// A list of configuration options that are available for a shortcut.
enum AssistantActionConfigurationOption: Identifiable {
    /// The specified shorcut can be added.
    case add(INShortcut)

    /// The specified shortcut can be edited.
    case edit(INVoiceShortcut)

    var id: ObjectIdentifier {
        switch self {
        case .add(let shortcut):
            switch shortcut {
            case .intent(let intent):
                return ObjectIdentifier(intent)
            case .userActivity(let userActivity):
                return ObjectIdentifier(userActivity)
            @unknown default:
                fatalError()
            }

        case .edit(let voiceShortcut):
            return ObjectIdentifier(voiceShortcut)
        }
    }
}
