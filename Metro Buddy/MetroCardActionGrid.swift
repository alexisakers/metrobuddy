import SwiftUI

struct MetroCardActionGrid: View {
    @Binding var textAlert: TextAlert?
    @Binding var isShowingDatePicker: Bool
    @EnvironmentObject private var viewModel: MetroCardViewModel

    // MARK: - Initialization
    
    init(textAlert: Binding<TextAlert?>, isShowingDatePicker: Binding<Bool>) {
        self._textAlert = textAlert
        self._isShowingDatePicker = isShowingDatePicker
    }
    
    // MARK: - View
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(alignment: .top, spacing: 16) {
                CardDetailsButton(
                    title: "BALANCE",
                    value: nil,
                    actionLabel: .update,
                    action: updateBalanceButtonTapped
                )

                CardDetailsButton(
                    title: "FARE",
                    value: viewModel.data.formattedFare,
                    actionLabel: .update,
                    action: updateFareButtonTapped
                )
            }
            
            HStack(alignment: .top, spacing: 16) {
                CardDetailsButton(
                    title: "EXPIRATION",
                    value: viewModel.data.formattedExpirationDate,
                    actionLabel: .add,
                    action: updateExpirationDateButtonTapped
                )

                CardDetailsButton(
                    title: "CARD NUMBER",
                    value: viewModel.data.formattedSerialNumber,
                    actionLabel: .add,
                    action: updateSerialNumberButtonTapped
                )
            }
        }
    }
    
    // MARK: - Input
    
    private func updateBalanceButtonTapped() {
        textAlert = .updateBalance(action: viewModel.saveBalance)
    }

    private func updateFareButtonTapped() {
        textAlert = .updateFare(action: viewModel.saveFare)
    }
    
    private func updateExpirationDateButtonTapped() {
        isShowingDatePicker = true
    }
    
    private func updateSerialNumberButtonTapped() {
        textAlert = .updateSerialNumber(action: viewModel.saveSerialNumber)
    }
}
