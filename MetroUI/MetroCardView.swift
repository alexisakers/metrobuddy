import SwiftUI

/// A view that mimics the appearance of a Metro Card, and displays its current balance.
public struct MetroCardView: View {
    public static let aspectRatioMultiplier: CGFloat = 1.585

    public let formattedBalance: String
    public let roundCorners: Bool
    public let aspectRatio: CGFloat

    // MARK: - Initialization

    public init(formattedBalance: String, roundCorners: Bool, aspectRatio: CGFloat = Self.aspectRatioMultiplier) {
        self.formattedBalance = formattedBalance
        self.roundCorners = roundCorners
        self.aspectRatio = aspectRatio
    }

    // MARK: - View
    
    public var body: some View {
        VStack(spacing: 0) {
            Spacer()

            Text(formattedBalance)
                .font(.cardBalance)
                .foregroundColor(.black)
                .padding(.horizontal, 16)
                .padding(.top, 8)

            Spacer()
            Rectangle()
                .foregroundColor(.black)
                .frame(height: 40)
                .padding(.bottom, 8)

            Image.Assets.metroCardArrows
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 12)
                .padding(.bottom, 8)
        }.background(
            LinearGradient(
                gradient: Gradient(colors: [.metroCardYellow, .metroCardOrange]),
                startPoint: .top,
                endPoint: .bottom
            )
        ).aspectRatio(aspectRatio, contentMode: .fill)
        .fixedSize(horizontal: false, vertical: true)
        .mask(MetroCardShape(roundCorners: roundCorners))
        .accessibilityElement(children: .ignore)
        .accessibility(addTraits: .isButton)
        .accessibility(label: Text("Card Balance"))
        .accessibility(value: Text(formattedBalance))
        .accessibility(identifier: "card")
    }
}
