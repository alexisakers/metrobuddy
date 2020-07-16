import SwiftUI
import MetroKit

/// Displays a full-screen error message in case the app is not available.
struct ErrorScreen: View {
    let error: ErrorMessage

    @State private var emailConfiguration: MailComposer.Configuration?
    @Environment(\.configuration) private var configuration
    @Environment(\.canSendMail) private var canSendMail

    // MARK: - View
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .lastTextBaseline, spacing: 8) {
                Image.Symbols.exclamationMarkTriangleFill
                    .accessibility(hidden: true)
                
                Text("Unexpected Issue")
            } .font(.sheetTitle)
            .padding(.bottom, 16)

            Text(error.localizedDescription)
                .font(.body)
                .multilineTextAlignment(.leading)

            if canSendMail {
                Text(error.contactCTA)
                    .font(.body)
                    .multilineTextAlignment(.leading)
                    .padding(.bottom, 16)
                
                RoundedButton(
                    title: Text("Contact Us"),
                    titleColor: .black,
                    background: Color.metroCardOrange,
                    design: .standard,
                    action: contactButtonTapped
                )
            }
        }.padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(BackgroundView())
        .mailComposer(configuration: $emailConfiguration)
    }
    
    // MARK: - Events
    
    private func contactButtonTapped() {
        emailConfiguration = .errorReport(appConfiguration: configuration, message: error)
    }
}
