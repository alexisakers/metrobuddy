import SwiftUI
import MetroKit

struct AssistantActionView: View {
    let item: AssistantActionListItem
    @Binding var activeConfiguration: AssistantActionConfigurationOption?

    var buttonTitle: Text {
        switch item.configurationOption {
        case .add:
            return Text("Add to Siri")
        case .edit:
            return Text("Edit Shortcut")
        }
    }

    var subtitle: Text {
        switch item.configurationOption {
        case .add:
            return Text(item.action.localizedDescription)
        case .edit(let voiceShortcut):
            return Text(item.action.localizedDescription(withPhrase: voiceShortcut.invocationPhrase))
        }
    }

    var accessoryIcon: some View {
        if case .edit = item.configurationOption {
            return Image(systemName: "checkmark.circle.fill")
                .font(.headline)
        } else {
            return Image(systemName: "plus.circle.fill")
                .font(.headline)
        }
    }

    var background: AnyView {
        return RoundedRectangle
        .defaultStyle
        .foregroundColor(Color("SiriPurple"))
        .eraseToAnyView()
    }

    var body: some View {
        Button(action: buttonTapped) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        accessoryIcon

                        Text(item.action.title)
                            .font(.headline)
                            .bold()
                    }

                    subtitle
                        .font(.footnote)
                }

                Spacer()
                Image(systemName: "chevron.right")
        }.padding(16)
            .frame(maxWidth: .infinity)
            .background(background)
            .accentColor(.white)
        }.buttonStyle(ScaleButtonStyle())
    }

    private func buttonTapped() {
        activeConfiguration = item.configurationOption
    }
}
