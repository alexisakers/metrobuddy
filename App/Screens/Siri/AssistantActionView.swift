import SwiftUI
import MetroKit

struct AssistantActionView: View {
    let item: AssistantActionListItem
    @Binding var activeConfiguration: AssistantActionConfiguration?

    var buttonTitle: Text {
        switch item.configuration {
        case .add:
            return Text("Add to Siri")
        case .edit:
            return Text("Edit Shortcut")
        }
    }

    var subtitle: Text {
        switch item.configuration {
        case .add:
            return Text(item.action.localizedDescription)
        case .edit(let voiceShortcut):
            return Text(item.action.localizedDescription(withPhrase: voiceShortcut.invocationPhrase))
        }
    }

    var accessoryIcon: some View {
        if case .edit = item.configuration {
            return Image(systemName: "checkmark.circle.fill")
                .font(.headline)
        } else {
            return Image(systemName: "plus.circle.fill")
                .font(.headline)
        }
    }

    var background: some View {
        switch item.configuration {
        case .add:
            return Color.prominentContainerBackground
        case .edit:
            return Color("SiriPurple")
        }
    }

    var body: some View {
        Button(action: buttonTapped) {
            HStack {
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
        .mask(RoundedRectangle.defaultStyle)
            .accentColor(.white)
        }.buttonStyle(ScaleButtonStyle())

    }

    private func buttonTapped() {
        activeConfiguration = item.configuration
    }
}
