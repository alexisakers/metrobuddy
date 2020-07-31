import SwiftUI

struct PlaceholderView: View {
    var body: some View {
        MetroWidgetView(entry: MetroTimelineEntry(date: Date(), cardStatus: .placeholder))
    }
}

