import IntentsUI
import SwiftUI
import MetroKit
import MetroUI

class IntentViewController: UIViewController, INUIHostedViewControlling {
    var desiredSize: CGSize {
        let maxWidth = self.extensionContext!.hostedViewMaximumAllowedSize.width
        return CGSize(width: maxWidth, height: maxWidth / MetroCardView.aspectRatioMultiplier)
    }

    // Prepare your view controller for the interaction to handle.
    func configureView(for parameters: Set<INParameter>, of interaction: INInteraction, interactiveBehavior: INUIInteractiveBehavior, context: INUIHostedViewContext, completion: @escaping (Bool, Set<INParameter>, CGSize) -> Void) {
        func completeWithoutUI() {
            completion(false, parameters, .zero)
        }

        // Handle supported responses
        guard
            let response = interaction.intentResponse as? BalanceProvidingIntentResponse,
            let balance = response.balance,
            let currencyCode = balance.currencyCode,
            let amount = balance.amount
        else {
            return completeWithoutUI()
        }

        let numberFormatter = NumberFormatter()
        numberFormatter.currencyCode = currencyCode
        numberFormatter.numberStyle = .currency

        guard let formattedBalance = numberFormatter.string(from: amount) else {
            return completeWithoutUI()
        }

        addResponseViewController(formattedBalance: formattedBalance)
        completion(true, parameters, desiredSize)
    }

    private func addResponseViewController(formattedBalance: String) {
        let rootView = IntentResponseView(formattedBalance: formattedBalance)

        let hostingController = UIHostingController(rootView: rootView)
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)

        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}
