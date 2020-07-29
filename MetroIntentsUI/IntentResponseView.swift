import SwiftUI
import MetroUI

/// A view that displays the response for an intent.
struct IntentResponseView: View {
    let formattedBalance: String

    var body: some View {
        ZStack {
            Color.contentBackground

            MetroCardView(formattedBalance: formattedBalance, roundCorners: true)
                .padding(.vertical, 8)
                .padding(.horizontal, 8 * MetroCardView.aspectRatioMultiplier)
        }
    }
}
