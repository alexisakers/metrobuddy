import SwiftUI
import MetroKit

/// A cell that displays a Siri shortcut.
struct ShortcutListCell: View {
    let item: ShortcutListItem
    @Binding var activeConfiguration: AssistantActionConfigurationOption?

    // MARK: - Subviews

    private var subtitle: Text {
        switch item.configurationOption {
        case .add:
            return Text(item.action.localizedDescription)
        case .edit(let voiceShortcut):
            return Text(item.action.localizedDescription(withPhrase: voiceShortcut.invocationPhrase))
        }
    }

    private var accessoryIcon: some View {
        if case .edit = item.configurationOption {
            return Image.Symbols.checkmarkCircleFill
                .font(.headline)
        } else {
            return Image.Symbols.plusCircleFill
                .font(.headline)
        }
    }

    private var background: some View {
        RoundedRectangle
            .defaultStyle
            .foregroundColor(.siriPurple)
    }

    // MARK: - View

    var body: some View {
        Button(action: buttonTapped) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        accessoryIcon

                        Text(verbatim: item.action.title)
                            .font(.headline)
                            .bold()
                    }

                    subtitle
                        .font(.footnote)
                }

                Spacer()

                Image.Symbols.chevronRight
                    .font(.body)
            }.padding(16)
            .frame(maxWidth: .infinity)
            .background(background)
            .accentColor(.white)
        }.buttonStyle(ScaleButtonStyle())
        .accessibility(addTraits: .isButton)
        .accessibilityElement(children: .ignore)
        .accessibility(label: Text(verbatim: item.accessibilityLabel))
        .accessibility(value: subtitle)
    }

    // MARK: - Input

    private func buttonTapped() {
        activeConfiguration = item.configurationOption
    }
}
