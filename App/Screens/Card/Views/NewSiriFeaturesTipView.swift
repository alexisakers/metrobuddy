import SwiftUI

struct NewSiriFeaturesTipView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center) {
                Image.Symbols.lightbulb
                    .accessibility(hidden: true)

                Text("NEW SIRI FEATURES")
                    .accessibility(label: Text("New Siri Features"))
                    .accessibility(addTraits: [.isHeader, .isStaticText])
                    .accessibility(identifier: "siri-tip-title")

                Spacer()
            }.font(.contentCardTitle)

            Text("MetroBuddy now works with Siri. Ask them “Swipe my MetroCard“ to update your balance on the go, or create shortcuts that fit your daily routine.")
                .font(.body)
                .accessibility(addTraits: .isStaticText)
                .accessibility(identifier: "tip-message")
                .fixedSize(horizontal: false, vertical: true)
        }.padding(16)
        .background(Color("SiriPurple"))
        .mask(RoundedRectangle.defaultStyle)
        .fixedSize(horizontal: false, vertical: true)
    }

    func configureButtonTapped() {
        print("Requesting permission")
    }
}
