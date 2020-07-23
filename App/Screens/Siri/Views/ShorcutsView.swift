import Intents
import SwiftUI

struct ShorcutsView: View {
    @ObservedObject var viewModel: ShorcutsViewModel
    @Binding var isPresented: Bool
    @Environment(\.haptics) var haptics

    @State private var activeConfiguration: AssistantActionConfigurationOption?

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SheetNavigationBar(
                title: Text("Siri Shortcuts"),
                isPresented: $isPresented
            )

            ForEach(viewModel.items) { item in
                AssistantActionView(
                    item: item,
                    activeConfiguration: self.$activeConfiguration
                )
            }

            SafeAreaSpacer(edge: .bottom)
        }.padding(16)
        .background(Color.contentBackground)
        .mask(RoundedRectangle.defaultStyle)
        .sheet(item: $activeConfiguration, content: makeSheet)
        .onAppear(perform: viewModel.reload)
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
