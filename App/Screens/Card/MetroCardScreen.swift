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
    @State private var isShowingShorcutList = false
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
                        ShortcutsButton(action: shortcutsButtonTapped)
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
                    ExpirationDatePickerModal(
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
        }.accessibilityElement(children: .contain)
        .onReceive(viewModel.toast, perform: toastQueue.displayToast)
        .onReceive(viewModel.taskCompletion, perform: haptics.notify)
        .sheet(isPresented: $isShowingShorcutList, content: makeShortcutList)
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
            isShowingShorcutList.toggle()
        }
    }

    // MARK: - Sheet

    private func makeShortcutList() -> some View {
        NavigationView {
            ShortcutList(
                viewModel: viewModel.makeShortcutListViewModel(),
                isPresented: $isShowingShorcutList
            ).navigationBarTitle("Siri Shortcuts", displayMode: .inline)
        }.colorScheme(.dark)
    }
}
