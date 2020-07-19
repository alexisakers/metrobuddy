import SwiftUI
import MetroKit

/// The screen that displays the user's Metro Card.
struct MetroCardScreen: View {
    @Environment(\.haptics) var haptics
    @Environment(\.configuration) var appConfiguration
    @Environment(\.enableAnimations) var enableAnimations

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
                VStack(alignment: .leading, spacing: 16) {
                    NavigationBar(subtitle: viewModel.data.formattedRemainingSwipes)
                        .accessibility(sortPriority: 0)

                    MetroCardView(formattedBalance: viewModel.data.formattedBalance)
                        .offset(offset)
                        .onTapGesture(perform: cardTapped)
                        .gesture(dragGesture)
                        .accessibilityAction(named: Text("Swipe Card"), recordSwipe)
                        .transition(.opacity)
                        .animation(enableAnimations ? Animation.spring() : nil, value: offset)

                    if viewModel.data.isOnboarded {
                        RoundedButton(
                            title: Text("Swipe"),
                            titleColor: .white,
                            background: Color.prominentContainerBackground,
                            design: .standard,
                            action: recordSwipe
                        ).accessibility(identifier: "swipe-button")
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
                .frame(maxWidth: 414)
            }.transition(.identity)
            .accessibility(hidden: isShowingDatePicker)
            .frame(maxWidth: .infinity)
            .zIndex(0)

            if isShowingDatePicker {
                ModalSheet(isPresented: $isShowingDatePicker) {
                    ExpirationDatePickerSheet(
                        initialValue: viewModel.data.expirationDate,
                        isPresented: $isShowingDatePicker,
                        saveHandler: { self.viewModel.saveExpirationDate($0) },
                        resetHandler: { self.viewModel.saveExpirationDate(nil) }
                    )
                }.transition(AnyTransition.opacity
                    .animation(enableAnimations ? Animation.easeInOut(duration: 0.25) : nil)
                ).accessibility(sortPriority: 1)
                .zIndex(1)
            }
        }.frame(maxWidth: .infinity)
        .accessibilityElement(children: .contain)
        .onReceive(viewModel.toast, perform: toastQueue.displayToast)
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
            recordSwipe()
            drag = 0
        } else {
            drag = 0
        }
    }
    
    private func recordSwipe() {
        guard enableAnimations else {
            return viewModel.recordSwipe()
        }

        isPerformingSwipe = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.viewModel.recordSwipe()
            self.isPerformingSwipe = false
        }
    }
}
