import SwiftUI
import MetroKit
import MetroUI

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

    private let cardSwipeThreshold: CGFloat = -100
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

                    MetroCardView(formattedBalance: viewModel.data.formattedBalance, roundCorners: true)
                        .offset(offset)
                        .animation(enableAnimations ? .spring() : nil, value: offset)
                        .onTapGesture(perform: cardTapped)
                        .gesture(dragGesture)
                        .accessibility(addTraits: .isButton)
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
        }.accessibilityElement(children: .contain)
        .accessibilityAction(.magicTap, viewModel.recordSwipe)
        .onAppear(perform: viewModel.donateCurrentBalance)
        .onReceive(viewModel.toast, perform: toastQueue.displayToast)
        .onReceive(viewModel.taskCompletion, perform: haptics.notify)
        .onReceive(viewModel.announcement, perform: handleAnnouncement)
        .sheet(isPresented: $isShowingShorcutList, content: makeShortcutList)
        .modalDrawer(isPresented: $isShowingDatePicker, content: makeDatePickerModal)
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
            if xTranslation <= cardSwipeThreshold && drag > cardSwipeThreshold {
                haptics.impact(style: .rigid)
            } else if xTranslation >= cardSwipeThreshold && drag < cardSwipeThreshold {
                haptics.impact(style: .soft)
            }

            drag = xTranslation
        }
    }
    
    private func dragGestureEnded(gesture: DragGesture.Value) {
        let xTranslation = gesture.translation.width
        if xTranslation < cardSwipeThreshold {
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

    private func handleAnnouncement(_ text: String) {
        UIAccessibility.post(notification: .announcement, argument: text)
    }

    // MARK: - Sheet

    private func makeShortcutList() -> some View {
        NavigationView {
            ShortcutList(
                viewModel: viewModel.makeShortcutListViewModel(),
                isPresented: $isShowingShorcutList
            ).navigationBarTitle("Siri Shortcuts", displayMode: .inline)
            .navigationBarItems(trailing: CloseButton(action: closeShortcutsButtonTapped))
        }.colorScheme(.dark)
        .accentColor(.metroCardOrange)
    }

    private func makeDatePickerModal() -> some View {
        ExpirationDatePickerModal(
            initialValue: viewModel.data.expirationDate,
            isPresented: $isShowingDatePicker,
            saveHandler: { self.viewModel.saveExpirationDate($0) },
            resetHandler: { self.viewModel.saveExpirationDate(nil) }
        )
    }

    private func closeShortcutsButtonTapped() {
        isShowingShorcutList = false
    }
}
