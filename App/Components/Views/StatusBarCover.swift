import SwiftUI

/// A view that hides a status bar.
struct StatusBarCover: View {
    var body: some View {
        GeometryReader { geometry in
            Color.contentBackground
                .frame(width: geometry.size.width, height: geometry.safeAreaInsets.top + 1)
                .edgesIgnoringSafeArea(.all)
        }.fixedSize(horizontal: false, vertical: true)
    }
}
