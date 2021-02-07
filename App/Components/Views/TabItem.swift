import SwiftUI

/// A view to display in a tab bar.
struct TabItem: View {
    let title: LocalizedStringKey
    let symbolName: String

    var body: some View {
        Label(title, systemImage: symbolName)
    }
}
