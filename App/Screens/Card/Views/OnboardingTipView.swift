import SwiftUI

/// A few that displays a tip to the user on how to get started with their card.
struct OnboardingTipView: View {
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
            
            Text("Tap on the card to enter your current card balance.")
                .font(.body)
                .accessibility(addTraits: .isStaticText)
                .accessibility(identifier: "tip-message")
        }.padding(16)
        .background(Color.prominentContainerBackground)
        .mask(RoundedRectangle.defaultStyle)
    }
}
