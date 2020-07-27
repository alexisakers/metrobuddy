import Intents
import SwiftUI

/// A view that displays a list of available Siri shortcuts, and allows the user to add/edit them.
struct ShortcutList: View {
    private typealias ShortcutList = ForEach<[ShortcutListItem], ShortcutListItem.ID, ShortcutListCell>

    @ObservedObject var viewModel: ShortcutListViewModel
    @Binding var isPresented: Bool

    @Environment(\.haptics) private var haptics
    @State private var activeConfiguration: AssistantActionConfigurationOption?

    // MARK: - Subviews

    private var activityIndicator: ActivityIndicator? {
        guard case .loading = viewModel.content else {
            return nil
        }

        return ActivityIndicator(style: .medium)
    }

    private var list: ShortcutList? {
        guard case let .loaded(items) = viewModel.content else {
            return nil
        }

        return ForEach(items) { item in
            ShortcutListCell(item: item, activeConfiguration: self.$activeConfiguration)
        }
    }

    private var errorMessage: AnyView? {
        guard case let .failure(errorMessage) = viewModel.content else {
            return nil
        }

        #warning("TODO Alexis: modularize")
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

    // MARK: - View

    var body: some View {
        FullWidthScrollView(bounce: .vertical) {
            Group {
                activityIndicator
                list
                errorMessage
            }.padding(16)
        }.onAppear(perform: viewModel.reload)
        .sheet(item: $activeConfiguration, content: makeSheet)
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
