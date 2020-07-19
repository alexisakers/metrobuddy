import SwiftUI

/// A view that displays a title for the screen.
struct NavigationBar: View {
    let subtitle: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("My Card")
                    .font(.screenTitle)
                    .foregroundColor(.white)
                    .minimumScaleFactor(0.1)
                    .lineLimit(1)
                    .accessibility(addTraits: .isHeader)

                Spacer()
            }

            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.white)
                .lineLimit(nil)
                .accessibility(addTraits: .isStaticText)
                .accessibility(identifier: "subtitle")
                .animation(nil)
        }.fixedSize(horizontal: false, vertical: true)
    }
}

// MARK: - Preview

struct NavigationBar_Preview: PreviewProvider {
    static var previews: some View {
        NavigationBar(subtitle: "1 swipe left")
            .background(BackgroundView())
    }
}
