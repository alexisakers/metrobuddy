import SwiftUI

/// A view that displays a title for the screen.
struct NavigationBar: View {
    let title: LocalizedStringKey
    let subtitle: String?
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .font(.screenTitle)
                    .foregroundColor(.white)
                    .minimumScaleFactor(0.1)
                    .lineLimit(1)
                    .accessibility(addTraits: .isHeader)

                Spacer()
            }

            if let subtitle = subtitle {
                Text(verbatim: subtitle)
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .lineLimit(nil)
                    .accessibility(addTraits: .isStaticText)
                    .accessibility(identifier: "subtitle")
            }
        }.fixedSize(horizontal: false, vertical: true)
        .padding(.leading, 10)
    }
}

// MARK: - Preview

struct NavigationBar_Preview: PreviewProvider {
    static var previews: some View {
        NavigationBar(title: "My Card", subtitle: "1 swipe left")
            .background(BackgroundView())
    }
}
