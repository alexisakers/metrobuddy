import SwiftUI

/// The main view of the app, presenting different screens at its state changes.
struct RootView: View {
    let viewModel: RootViewModel
    @EnvironmentObject var toastQueue: ToastQueue

    // MARK: - View

    var body: some View {
        ZStack(alignment: .top) {
            contentView
                .edgesIgnoringSafeArea(.all)
                .zIndex(0)
                .accessibilityElement(children: .contain)

            GeometryReader { geometry in
                Color.contentBackground
                    .frame(width: geometry.size.width, height: geometry.safeAreaInsets.top)
            }.fixedSize(horizontal: false, vertical: true)
                .edgesIgnoringSafeArea(.all)
                .zIndex(1)

            toastQueue.toastText.map { toastText in
                Toast(text: toastText)
                    .zIndex(2)
            }.transition(
                AnyTransition
                    .move(edge: .top)
                    .combined(with: .opacity)
            )

        }.background(BackgroundView())
        .accessibilityElement(children: .contain)
    }
    
    var contentView: some View {
        switch viewModel.content {
        case .card(let viewModel):
            return MetroCardScreen()
                .environmentObject(viewModel)
                .eraseToAnyView()

        case .appUnavailable(let error):
            return ErrorScreen(error: error)
                .eraseToAnyView()
        }
    }
}
