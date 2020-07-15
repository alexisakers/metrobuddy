import SwiftUI

struct RootView: View {
    let viewModel: RootViewModel
    @ObservedObject var toastQueue: ToastQueue
    
    var contentView: some View {
        switch viewModel.content {
        case .card(let viewModel):
            return ContentView()
                .environmentObject(viewModel)
                .environmentObject(toastQueue)
                .eraseToAnyView()
        case .appUnavailable(let error):
            return ErrorScreen(error: error)
                .eraseToAnyView()
        }
    }
    
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
        }
    }
}
