import SwiftUI

struct OnboardingTipView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center) {
                Image(systemName: "lightbulb")
                Text("TIP")
                Spacer()
            }.component(.cardTitle)
            
            Text("Tap on the card or the “Update Balance” button below to enter your current card balance.")
                .font(.body)
        }.padding(16)
        .background(Color("ProminentContainerBackground"))
        .mask(RoundedRectangle.defaultStyle)
    }
}
