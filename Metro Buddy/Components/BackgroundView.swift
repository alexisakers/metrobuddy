import SwiftUI

/// A view to display behind the content.
struct BackgroundView: View {
    var body: some View {
        Color.contentBackground
            .edgesIgnoringSafeArea(.all)
    }
}
