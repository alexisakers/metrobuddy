import SwiftUI

/// The main view of the app, presenting different screens at its state changes.
struct RootView: View {
    let viewModel: RootViewModel
    @EnvironmentObject var toastQueue: ToastQueue
    
    // MARK: - View
        
    var body: some View {
        ZStack(alignment: .top) {
            contentView
                .zIndex(0)

            if let toastText = toastQueue.toastText {
                Toast(text: toastText)
                    .animation(Animation.spring().speed(2))
                    .transition(
                        AnyTransition
                            .move(edge: .top)
                            .combined(with: .opacity)
                    )
                    .zIndex(1)
            }
        }.background(BackgroundView())
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
