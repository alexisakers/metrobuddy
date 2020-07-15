import SwiftUI

struct NavigationBar: View {
    let subtitle: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("My Card")
                    .component(.screenTitle)
                    .foregroundColor(.white)

                Spacer()
            }

            Text(subtitle)
                .font(.subheadline)
        }
    }
}
