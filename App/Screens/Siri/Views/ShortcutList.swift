import SwiftUI
import MetroKit

/// A view that displays a list of available Siri shortcuts, and allows the user to add/edit them.
struct ShortcutList: View {
    @ObservedObject var viewModel: ShortcutListViewModel
    @Binding var isPresented: Bool

    @Environment(\.haptics) private var haptics
    @State private var activeConfiguration: AssistantActionConfigurationOption?
    @State private var configurationErrorMessage: ErrorMessage?

    // MARK: - Subviews

    private var activityIndicator: ActivityIndicator? {
        guard case .loading = viewModel.content else {
            return nil
        }

        return ActivityIndicator(style: .medium)
    }

    private var list: AnyView? {
        guard case let .loaded(items) = viewModel.content else {
            return nil
        }

        return ForEach(items) { item in
            ShortcutListCell(item: item, activeConfiguration: self.$activeConfiguration)
                .padding(.bottom, 16)
        }.eraseToAnyView()
    }

    private var errorMessage: ShortcutListErrorView? {
        guard case let .failure(errorMessage) = viewModel.content else {
            return nil
        }

        return ShortcutListErrorView(errorMessage: errorMessage, retryAction: viewModel.reload)
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
        .alert(item: $configurationErrorMessage, content: makeConfigurationErrorAlert)
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

    private func addVoiceShortcutViewDismissed(errorMessage: ErrorMessage?) {
        activeConfiguration = nil
        configurationErrorMessage = errorMessage
        viewModel.reload()
        notifyCompletion(errorMessage: errorMessage)
    }

    private func editVoiceShortcutViewDismissed(errorMessage: ErrorMessage?) {
        activeConfiguration = nil
        viewModel.reload()
        notifyCompletion(errorMessage: errorMessage)
    }

    private func notifyCompletion(errorMessage: ErrorMessage?) {
        haptics.notify(completion: errorMessage == nil ? .success : .failure)
    }

    // MARK: - Helpers

    private func makeConfigurationErrorAlert(_ message: ErrorMessage) -> Alert {
        Alert(errorMessage: message)
    }
}
