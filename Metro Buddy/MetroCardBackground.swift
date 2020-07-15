import SwiftUI

struct MetroCardView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
        
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color("MetroCardYellow"),
                Color("MetroCardOrange")
            ]),
            startPoint: .top,
            endPoint: .bottom
        ).aspectRatio(1.585, contentMode: .fill)
        .overlay(VStack(spacing: 0) {
            Spacer()

            content
                .padding(.horizontal, 20)
                .padding(.top, 10)

            Spacer()
            Rectangle()
                .foregroundColor(.black)
                .frame(height: 40)
                .padding(.bottom, 10)

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
