import Foundation
import MetroKit

/// A list item that displays an assistant action and its available options.
struct ShortcutListItem: Identifiable {
    /// The action available to the user.
    let action: AssistantAction

    /// The option available for the action.
    let configurationOption: AssistantActionConfigurationOption

    var id: Int {
        var hasher = Hasher()
        hasher.combine(action)
        hasher.combine(configurationOption.id)
        return hasher.finalize()
    }
}

