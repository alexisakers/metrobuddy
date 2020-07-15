import SwiftUI

/// The screen that displays the user's Metro Card.
struct MetroCardScreen: View {
    @Environment(\.haptics) var haptics
    @EnvironmentObject var toastQueue: ToastQueue
    @EnvironmentObject var viewModel: MetroCardViewModel

    @State private var textAlert: TextAlert?
    @State private var isShowingDatePicker = false
    @State private var expirationDate = Date()

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
            VStack(spacing: 20) {
                NavigationBar(subtitle: viewModel.data.formattedRemainingSwipes)
                
                MetroCardView(formattedBalance: viewModel.data.formattedBalance)
                    .offset(offset)
                    .onTapGesture(perform: cardTapped)
                    .gesture(dragGesture)
                    .animation(.spring())
                                
                if viewModel.showOnboarding {
                    OnboardingTipView()
                } else {
                    RoundedButton(
                        title: Text("Swipe"),
                        titleColor: .white,
                        background: Color.prominentContainerBackground,
                        padding: .standard,
                        action: commitSwipe
                    )
                }
                
                MetroCardActionGrid(
                    textAlert: $textAlert,
                    isShowingDatePicker: $isShowingDatePicker
                )
                
                Spacer()
            }.padding(.all, 16)
            .background(BackgroundView())
            .zIndex(0)
            
            if isShowingDatePicker {
                ModalSheet(isPresented: $isShowingDatePicker) {
                    ExpirationDatePickerSheet(
                        initialValue: viewModel.data.source.expirationDate,
                        isPresented: $isShowingDatePicker,
                        saveHandler: { viewModel.perform(update: .expirationDate($0)) },
                        resetHandler: { viewModel.perform(update: .expirationDate(nil)) }
                    )
                }.transition(.opacity)
                .zIndex(1)
            }
        }.onReceive(viewModel.tooltip, perform: toastQueue.displayToast)
        .onReceive(viewModel.completedTasks, perform: taskDidComplete)
        .textAlert(item: $textAlert)
        .alert(item: $viewModel.error) { errorMessage in
            Alert(title: Text(errorMessage.title))
        }
    }
    
    // MARK: - Actions
    
    private func cardTapped() {
        textAlert = .updateBalance(action: viewModel.saveBalance)
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
                commitSwipe()
                drag = 0
            }
        } else {
            withAnimation {
                drag = 0
            }
        }
    }
    
    private func commitSwipe() {
        withAnimation(.easeIn(duration: 0.3)) {
            isPerformingSwipe = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                viewModel.swipe()
                withAnimation(.easeOut(duration: 0.3)) {
                    self.isPerformingSwipe = false
                }
            }
        }
    }
    
    private func taskDidComplete(completion: TaskCompletion) {
        switch completion {
        case .success:
            haptics.success()
        case .failure:
            haptics.failure()
        }
    }
}
