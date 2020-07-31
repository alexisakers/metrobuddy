import SwiftUI
import WidgetKit
import MetroUI

/// A view to use as the background of the widget.
struct MetroWidgetBackgroundView: View {
    @Environment(\.widgetFamily) var widgetFamily

    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [.metroCardYellow, .metroCardOrange]),
            startPoint: .top,
            endPoint: .bottom
        ).mask(
            MetroCardShape(
                roundCorners: false,
                cornerSizeMultiplier: widgetFamily.isCompact ? 0.3 : 0.2
            )
        ).background(Color.contentBackground)
    }
}
