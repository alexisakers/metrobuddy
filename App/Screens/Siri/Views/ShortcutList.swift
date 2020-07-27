import Intents
import SwiftUI

/// A view that displays a list of available Siri shortcuts, and allows the user to add/edit them.
struct ShortcutList: View {
    @ObservedObject var viewModel: ShortcutListViewModel
    @Binding var isPresented: Bool
    @Environment(\.haptics) var haptics

    @State private var activeConfiguration: AssistantActionConfigurationOption?

    var activityIndicator: ActivityIndicator? {
        guard case .loading = viewModel.content else {
            return nil
        }

        return ActivityIndicator(style: .medium)
    }

    var list: AnyView? {
        guard case let .loaded(items) = viewModel.content else {
            return nil
        }

        return ForEach(items) { item in
            AssistantActionView(
                item: item,
                activeConfiguration: self.$activeConfiguration
            )
        }.eraseToAnyView()
    }

    var errorMessage: AnyView? {
        guard case let .failure(errorMessage) = viewModel.content else {
            return nil
        }

        return VStack(alignment: .leading, spacing: 16) {
            Text(errorMessage.title)
            Text(errorMessage.localizedDescription)
            Text(errorMessage.diagnosticMessage)

            RoundedButton(
                title: Text("Try Again"),
                titleColor: .white,
                background: Color("SiriPurple"),
                design: .standard,
                action: viewModel.reload
            )
        }.eraseToAnyView()
    }

    var body: some View {
        NavigationView {
            FullWidthScrollView(bounce: .vertical) {
                Group {
                    activityIndicator
                    list
                    errorMessage
                }.padding(16)
            }.navigationBarTitle("Siri Shortcuts", displayMode: .inline)
        }.sheet(item: $activeConfiguration, content: makeSheet)
        .onAppear(perform: viewModel.reload)
            .colorScheme(.dark)
    }

    // MARK: - Inputs

    private func makeSheet(for configuration: AssistantActionConfigurationOption) -> AnyView {
        switch configuration {
        case .add(let shortcut):
            return AddVoiceShortcutView(shortcut: shortcut, dismiss: addVoiceShortcutViewDismissed)
                .eraseToAnyView()

        case .edit(let voiceShortcut):
            return EditVoiceShortcutView(shortcut: voiceShortcut, dismiss: editVoiceShortcutViewDismissed)
                .eraseToAnyView()
        }
    }

    private func addVoiceShortcutViewDismissed() {
        activeConfiguration = nil
        viewModel.reload()
    }

    private func editVoiceShortcutViewDismissed() {
        activeConfiguration = nil
        viewModel.reload()
        haptics.success()
    }
}
