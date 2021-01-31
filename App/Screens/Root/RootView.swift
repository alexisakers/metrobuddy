import SwiftUI

/// The main view of the app, presenting different screens at its state changes.
struct RootView: View {
    let viewModel: RootViewModel
    @EnvironmentObject private var toastQueue: ToastQueue

    // MARK: - View

    var body: some View {
        ZStack(alignment: .top) {
            contentView
                .edgesIgnoringSafeArea(.all)
                .accessibilityElement(children: .contain)
                .zIndex(0)

            StatusBarCover()
                .zIndex(1)

            toastQueue.toastText.map { toastText in
                Toast(text: toastText)
                    .zIndex(2)
            }.transition(
                AnyTransition
                    .move(edge: .top)
                    .combined(with: .opacity)
            )
        }
        .background(BackgroundView())
        .accessibilityElement(children: .contain)
    }
    
    @ViewBuilder var contentView: some View {
        switch viewModel.content {
        case .card(let viewModels):
            TabView {
                MetroCardScreen()
                    .environmentObject(viewModels.card)
                    .tabItem {
                        TabItem(title: "My Card", symbolName: "creditcard.fill")
                    }

                HistoryScreen()
                    .environmentObject(viewModels.history)
                    .tabItem {
                        TabItem(title: "History", symbolName: "calendar")
                    }
            }

        case .appUnavailable(let error):
            ErrorScreen(error: error)
        }
    }
}
