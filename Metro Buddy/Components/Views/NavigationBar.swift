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

                Spacer()
            }

            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.white)
        }
    }
}

// MARK: - Preview

struct NavigationBar_Preview: PreviewProvider {
    static var previews: some View {
        NavigationBar(subtitle: "1 swipe left")
            .background(BackgroundView())
    }
}
