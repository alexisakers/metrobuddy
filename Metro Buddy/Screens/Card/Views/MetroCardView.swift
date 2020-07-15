import SwiftUI

struct MetroCardView: View {
    let formattedBalance: String
        
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [.metroCardYellow, .metroCardOrange]),
            startPoint: .top,
            endPoint: .bottom
        ).aspectRatio(1.585, contentMode: .fill)
        .overlay(VStack(spacing: 0) {
            Spacer()

            Text(formattedBalance)
                .font(.system(size: 50, weight: .bold, design: .rounded))
                .foregroundColor(.black)
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .animation(nil)

            Spacer()
            Rectangle()
                .foregroundColor(.black)
                .frame(height: 40)
                .padding(.bottom, 8)

            Image("MetroCardArrows")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 12)
                .padding(.bottom, 10)
        }, alignment: .bottom)
        .mask(MetroCardShape())
        .fixedSize(horizontal: false, vertical: true)
        .accessibilityElement(children: .combine)
    }
}
