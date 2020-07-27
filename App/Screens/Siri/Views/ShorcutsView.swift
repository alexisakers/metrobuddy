import Intents
import SwiftUI

struct ActivityIndicator: UIViewRepresentable {
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView(style: style)
        view.startAnimating()
        return view
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        // no-op
    }
}

struct ShorcutsView: View {
    @ObservedObject var viewModel: ShorcutsViewModel
    @Binding var isPresented: Bool
    @Environment(\.haptics) var haptics

    @State private var activeConfiguration: AssistantActionConfigurationOption?

    var activityIndicator: ActivityIndicator? {
        guard case .loading = viewModel.state else {
            return nil
        }

        return ActivityIndicator(style: .medium)
    }

    var list: AnyView? {
        guard case let .loaded(items) = viewModel.state else {
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
        guard case let .failure(error) = viewModel.state else {
            return nil
        }

        return VStack(alignment: .leading, spacing: 16) {
            Text("Could not load shortcuts.")
            Text("An unexpected error occured (\(error)). Please try again, or try using the Shortcuts app directly.")

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
