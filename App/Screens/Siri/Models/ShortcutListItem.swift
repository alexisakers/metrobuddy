import Foundation
import MetroKit

/// A list item that displays an assistant action and its available options.
struct ShortcutListItem: Identifiable {
    /// The action available to the user.
    let action: AssistantAction

    /// The option available for the action.
    let configurationOption: AssistantActionConfigurationOption

    /// The accessibility label of the cell.
    let accessibilityLabel: String

    var id: Int {
        var hasher = Hasher()
        hasher.combine(action)
        hasher.combine(configurationOption.id)
        hasher.combine(accessibilityLabel)
        return hasher.finalize()
    }
}

