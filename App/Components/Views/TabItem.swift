import SwiftUI

/// A view to display in a tab bar.
struct TabItem: View {
    enum Icon {
        case asset(String)
        case symbol(String)
    }

    let title: LocalizedStringKey
    let icon: Icon

    var body: some View {
        switch icon {
        case .asset(let name):
            Label(title, image: name)
        case .symbol(let name):
            Label(title, systemImage: name)
        }
    }
}
