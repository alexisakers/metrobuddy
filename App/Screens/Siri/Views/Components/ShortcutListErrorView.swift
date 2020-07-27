import SwiftUI
import MetroKit

struct ShortcutListErrorView: View {
    let errorMessage: ErrorMessage
    let retryAction: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(errorMessage.title)
                .font(.headline)

            Text(errorMessage.localizedDescription)
                .font(.body)

            Spacer(minLength: 8)

            RoundedButton(
                title: Text("Try Again"),
                titleColor: .white,
                background: Color.siriPurple,
                design: .standard,
                action: retryAction
            )
        }
    }
}
