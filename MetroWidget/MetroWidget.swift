import SwiftUI
import WidgetKit
import MetroKit

@main
struct MetroWidget: Widget {
    public var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: WidgetKind.card.rawValue,
            provider: MetroTimelineProvider(),
            placeholder: PlaceholderView(),
            content: MetroWidgetView.init
        ).configurationDisplayName("MetroCard Balance")
        .description("Displays your MetroCard balance and how many swipes are left.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// MARK: - Previews

#if DEBUG
extension MetroTimelineEntry.CardStatus {
    static var preview: Self {
        Self(balance: "$25.00", remainingSwipes: "8 left")
    }
}

struct MetroWidget_Previews: PreviewProvider {
    static var previews: some View {
        MetroWidgetView(entry: MetroTimelineEntry(date: Date(), cardStatus: .placeholder))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
#endif
