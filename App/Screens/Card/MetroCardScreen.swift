import SwiftUI
import MetroKit
import Intents

/// The screen that displays the user's Metro Card.
struct MetroCardScreen: View {
    @Environment(\.haptics) var haptics
    @Environment(\.configuration) var appConfiguration
    @Environment(\.enableAnimations) var enableAnimations

    @EnvironmentObject var toastQueue: ToastQueue
    @EnvironmentObject var viewModel: MetroCardViewModel

    @State private var textFieldAlert: TextFieldAlert?
    @State private var isShowingDatePicker = false
    @State private var isShowingShorcutsSummary = false
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
        ZStack(alignment: .top) {
            FullWidthScrollView(bounce: []) {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        NavigationBar(subtitle: viewModel.data.formattedRemainingSwipes)
                            .accessibility(sortPriority: 0)

                        Spacer()

                        Button(action: shortcutsButtonTapped) {
                            Image("SiriButton")
                        }.buttonStyle(ScaleButtonStyle())
                        .accessibilityElement(children: .ignore)
                        .accessibility(identifier: "shortcuts-button")
                        .accessibility(label: Text("Siri Shortcuts"))
                    }

                    MetroCardView(formattedBalance: viewModel.data.formattedBalance)
                        .offset(offset)
                        .animation(enableAnimations ? Animation.spring() : nil, value: offset)
                        .onTapGesture(perform: cardTapped)
                        .gesture(dragGesture)
                        .accessibilityAction(named: Text("Swipe Card"), recordSwipe)

                    if viewModel.data.isOnboarded {
                        Group {
                            RoundedButton(
                                title: Text("Swipe"),
                                titleColor: .white,
                                background: Color.prominentContainerBackground,
                                design: .standard,
                                action: recordSwipe
                            ).accessibility(identifier: "swipe-button")

                            MetroCardActionGrid(
                                textFieldAlert: $textFieldAlert,
                                isShowingDatePicker: $isShowingDatePicker
                            )
                        }.transition(.opacity)
                          .animation(.easeInOut)
                    } else {
                        OnboardingTipView()
                            .transition(.opacity)
                            .animation(.easeInOut)
                    }

                    Spacer()
                }.padding(.all, 16)
                    .background(BackgroundView())

            }.accessibility(hidden: isShowingDatePicker)
            .zIndex(0)

            GeometryReader { geometry in
                 Color.contentBackground
                     .frame(width: geometry.size.width, height: geometry.safeAreaInsets.top + 1)
             }.fixedSize(horizontal: false, vertical: true)
                 .edgesIgnoringSafeArea(.all)
                 .zIndex(1)

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
                .zIndex(2)
            }

            if isShowingShorcutsSummary {
                ModalSheet(isPresented: $isShowingShorcutsSummary) {
                    ShorcutsView(viewModel: ShorcutsViewModel(), isPresented: $isShowingShorcutsSummary)
                }.transition(AnyTransition.opacity
                    .animation(enableAnimations ? Animation.easeInOut(duration: 0.25) : nil)
                ).accessibility(sortPriority: 1)
                .zIndex(3)
            }
        }.accessibilityElement(children: .contain)
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

    private func shortcutsButtonTapped() {
        withAnimation {
            isShowingShorcutsSummary.toggle()
        }
    }
}
