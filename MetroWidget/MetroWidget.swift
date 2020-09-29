import SwiftUI
import WidgetKit
import MetroKit

@main
struct MetroWidget: Widget {
    public var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: WidgetKind.cardBalance.rawValue,
            provider: MetroTimelineProvider(),
            content: MetroWidgetView.init
        ).configurationDisplayName("MetroCard Balance")
        .description("Displays your MetroCard balance and how many rides are left.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// MARK: - Previews

#if DEBUG
extension MetroTimelineEntry.CardStatus {
    static var preview: Self {
        Self(balance: "$25.00", remainingRides: "8 left", isPlaceholder: false, accessibilityValue: "$25, 8 rides left")
    }
}

struct MetroWidget_Previews: PreviewProvider {
    static var previews: some View {
        MetroWidgetView(entry: MetroTimelineEntry(date: Date(), cardStatus: .placeholder))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
#endif
