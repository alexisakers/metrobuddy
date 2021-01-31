import SwiftUI

/// A view to display in a tab bar.
struct TabItem: View {
    let title: LocalizedStringKey
    let symbolName: String

    var body: some View {
        if #available(iOS 14, *) {
            Label(title, systemImage: symbolName)
        } else {
            VStack {
                Image(systemName: symbolName)
                Text(title)
            }
        }
    }
}
