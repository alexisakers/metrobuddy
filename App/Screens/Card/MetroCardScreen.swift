import SwiftUI
import MetroKit

/// The screen that displays the user's Metro Card.
struct MetroCardScreen: View {
    @Environment(\.haptics) var haptics
    @Environment(\.configuration) var appConfiguration
    @EnvironmentObject var toastQueue: ToastQueue
    @EnvironmentObject var viewModel: MetroCardViewModel

    @State private var textFieldAlert: TextFieldAlert?
    @State private var isShowingDatePicker = false
    @State private var expirationDate = Date()
    @State private var emailConfiguration: MailComposer.Configuration?

    // MARK: - Gestures

    @State private var isPerformingSwipe: Bool = false
    @State private var drag: CGFloat = 0

    var dragGesture: some Gesture {
        DragGesture()
            .onChanged(dragGestureChanged)
            .onEnded(dragGestureEnded)
    }
    
    var offset: CGSize {
        if isPerformingSwipe {
            return CGSize(width: -500, height: 0)
        } else {
            return CGSize(width: drag, height: 0)
        }
    }

    // MARK: - View
    
    var body: some View {
        ZStack(alignment: .center) {
            ScrollView(.vertical) {
                VStack(spacing: 16) {
                    NavigationBar(subtitle: viewModel.data.formattedRemainingSwipes)

                    MetroCardView(formattedBalance: viewModel.data.formattedBalance)
                        .offset(offset)
                        .onTapGesture(perform: cardTapped)
                        .gesture(dragGesture)
                        .animation(.spring())
                        .transition(.identity)

                    if viewModel.data.isOnboarded {
                        RoundedButton(
                            title: Text("Swipe"),
                            titleColor: .white,
                            background: Color.prominentContainerBackground,
                            design: .standard,
                            action: recordSwipe
                        )
                    } else {
                        OnboardingTipView()
                    }

                    MetroCardActionGrid(
                        textFieldAlert: $textFieldAlert,
                        isShowingDatePicker: $isShowingDatePicker
                    )

                    Spacer()
                }.padding(.all, 16)
                .background(BackgroundView())
            }.zIndex(0)

            if isShowingDatePicker {
                ModalSheet(isPresented: $isShowingDatePicker) {
                    ExpirationDatePickerSheet(
                        initialValue: viewModel.data.expirationDate,
                        isPresented: $isShowingDatePicker,
                        saveHandler: { viewModel.saveExpirationDate($0) },
                        resetHandler: { viewModel.saveExpirationDate(nil) }
                    )
                }.transition(.opacity)
                .zIndex(1)
            }
        }.onReceive(viewModel.toast, perform: toastQueue.displayToast)
        .onReceive(viewModel.taskCompletion, perform: haptics.notify)
        .textFieldAlert(item: $textFieldAlert)
        .mailComposer(configuration: $emailConfiguration)
        .alert(item: $viewModel.errorMessage) {
            Alert(errorMessage: $0, configuration: appConfiguration, emailConfiguration: $emailConfiguration)
        }
    }
    
    // MARK: - Actions
    
    private func cardTapped() {
        textFieldAlert = .updateBalance(validator: viewModel.validateBalance, action: viewModel.saveBalance)
    }
    
    private func dragGestureChanged(gesture: DragGesture.Value) {
        let xTranslation = gesture.translation.width
        if xTranslation < 0 {
            drag = xTranslation
        }
    }
    
    private func dragGestureEnded(gesture: DragGesture.Value) {
        let xTranslation = gesture.translation.width
        if xTranslation < -100 {
            withAnimation {
                recordSwipe()
                drag = 0
            }
        } else {
            withAnimation {
                drag = 0
            }
        }
    }
    
    private func recordSwipe() {
        withAnimation(.easeIn(duration: 0.25)) {
            isPerformingSwipe = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                viewModel.recordSwipe()
                withAnimation(.spring()) {
                    self.isPerformingSwipe = false
                }
            }
        }
    }
}
