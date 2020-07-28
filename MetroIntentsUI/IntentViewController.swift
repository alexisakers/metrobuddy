import IntentsUI
import MetroKit
import MetroUI
import SwiftUI

class IntentViewController: UIViewController, INUIHostedViewControlling {
    @IBOutlet weak var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
        
    // MARK: - INUIHostedViewControlling
    
    // Prepare your view controller for the interaction to handle.
    func configureView(for parameters: Set<INParameter>, of interaction: INInteraction, interactiveBehavior: INUIInteractiveBehavior, context: INUIHostedViewContext, completion: @escaping (Bool, Set<INParameter>, CGSize) -> Void) {
        if let swipeCardResponse = interaction.intentResponse as? MBYSwipeCardIntentResponse {
            guard let balance = swipeCardResponse.balance else {
                return completion(false, parameters, .zero)
            }

            configure(with: balance)


        } else if let checkBalanceResponse = interaction.intentResponse as? MBYCheckBalanceIntentResponse {
            guard let balance = checkBalanceResponse.balance else {
                return completion(false, parameters, .zero)
            }

            configure(with: balance)
        } else {
            return completion(false, parameters, .zero)
        }

        completion(true, parameters, desiredSize)
    }

    private func configure(with balance: INCurrencyAmount) -> Bool {
        guard let currencyCode = balance.currencyCode, let amount = balance.amount else {
            return false
        }

        let numberFormatter = NumberFormatter()
        numberFormatter.currencyCode = currencyCode
        numberFormatter.numberStyle = .currency

        if let string = numberFormatter.string(from: amount) {
            let root = ZStack {
                Color.contentBackground
                MetroCardView(formattedBalance: string, roundCorners: true)
                    .padding(8)
            }

            let hostingController = UIHostingController(rootView: root)
            hostingController.willMove(toParent: self)
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
            return true
        } else {
            return false
        }
    }
    
    var desiredSize: CGSize {
        let maxWidth = self.extensionContext!.hostedViewMaximumAllowedSize.width
        return CGSize(width: maxWidth, height: maxWidth / MetroCardView.aspectRatioMultiplier + 16)
    }
}
