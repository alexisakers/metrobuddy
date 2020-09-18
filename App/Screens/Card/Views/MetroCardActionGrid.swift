import SwiftUI

/// A view that displays a grid of actions for the card.
struct MetroCardActionGrid: View {
    @Binding var textFieldAlert: TextFieldAlert?
    @Binding var isShowingDatePicker: Bool
    @EnvironmentObject private var viewModel: MetroCardViewModel

    // MARK: - View
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            FlexibleStack(hStackAlignment: .top, vStackAlignment: .leading) {
                MetroCardActionButton(
                    title: Text("BALANCE"),
                    value: nil,
                    actionLabel: .update,
                    action: updateBalanceButtonTapped
                ).accessibility(identifier: "balance-button")

                MetroCardActionButton(
                    title: Text("FARE"),
                    value: Text(verbatim: viewModel.data.formattedFare),
                    actionLabel: .update,
                    action: updateFareButtonTapped
                ).accessibility(identifier: "fare-button")
            }
            
            FlexibleStack(hStackAlignment: .top, vStackAlignment: .leading) {
                MetroCardActionButton(
                    title: Text("EXPIRATION"),
                    value: viewModel.data.formattedExpirationDate.map(Text.init(verbatim:)),
                    actionLabel: .add,
                    action: updateExpirationDateButtonTapped
                ).accessibility(identifier: "expiration-button")

                MetroCardActionButton(
                    title: Text("CARD NUMBER"),
                    value: viewModel.data.formattedSerialNumber.map(Text.init(verbatim:)),
                    actionLabel: .add,
                    action: updateSerialNumberButtonTapped
                ).accessibility(identifier: "card-number-button")
            }
        }
    }
    
    // MARK: - Input
    
    private func updateBalanceButtonTapped() {
        textFieldAlert = .updateBalance(validator: viewModel.validateBalance, action: viewModel.saveBalance)
    }

    private func updateFareButtonTapped() {
        textFieldAlert = .updateFare(validator: viewModel.validateFare, action: viewModel.saveFare)
    }
    
    private func updateExpirationDateButtonTapped() {
        withAnimation {
            isShowingDatePicker.toggle()
        }
    }
    
    private func updateSerialNumberButtonTapped() {
        textFieldAlert = .updateSerialNumber(validator: viewModel.validateSerialNumber, action: viewModel.saveSerialNumber)
    }
}
