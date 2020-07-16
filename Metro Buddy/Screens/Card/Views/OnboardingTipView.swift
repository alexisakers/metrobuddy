import SwiftUI

/// A few that displays a tip to the user on how to get started with their card.
struct OnboardingTipView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center) {
                Image.Symbols.lightbulb
                Text("TIP")
                Spacer()
            }.font(.contentCardTitle)
            
            Text("Tap on the card or the “Update Balance” button below to enter your current card balance.")
                .font(.body)
        }.padding(16)
        .background(Color.prominentContainerBackground)
        .mask(RoundedRectangle.defaultStyle)
    }
}
