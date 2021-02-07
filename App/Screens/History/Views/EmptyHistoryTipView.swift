import SwiftUI

/// A tip view that is displayed when there's no history.
struct EmptyHistoryTipView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center) {
                Image.Symbols.lightbulb
                    .accessibility(hidden: true)

                Text("TIP")
                    .accessibility(label: Text("Tip"))
                    .accessibility(addTraits: [.isHeader, .isStaticText])
                    .accessibility(identifier: "tip-title")

                Spacer()
            }.font(.contentCardTitle)

            Text("All reloads and swipes recorded in the app will appear here.")
                .font(.body)
                .accessibility(addTraits: .isStaticText)
                .accessibility(identifier: "tip-message")
        }.padding(16)
        .background(Color.prominentContainerBackground)
        .mask(RoundedRectangle.defaultStyle)
        .fixedSize(horizontal: false, vertical: true)
    }
}
