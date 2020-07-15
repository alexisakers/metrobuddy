import SwiftUI

struct ContentView: View {
    @Environment(\.haptics) var haptics
    @EnvironmentObject var toastQueue: ToastQueue
    @EnvironmentObject var viewModel: MetroCardViewModel

    @State private var drag: CGFloat = 0
    @State private var expirationDate = Date()
    @State private var isPerformingSwipe: Bool = false
    @State private var textAlert: TextAlert?
    @State private var isShowingDatePicker: Bool = false
    
    var offset: CGSize {
        if isPerformingSwipe {
            return CGSize(width: -500, height: 0)
        } else {
            return CGSize(width: drag, height: 0)
        }
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            VStack(spacing: 20) {
                NavigationBar(subtitle: viewModel.data.formattedRemainingSwipes)
                
                MetroCardView {
                    VStack {
                        Text(viewModel.data.formattedBalance)
                            .foregroundColor(.black)
                            .font(.system(size: 50, weight: .bold, design: .rounded))
                            .padding(.horizontal, 20)
                            .animation(nil)
                    }
                }.offset(offset)
                .onTapGesture {
                    textAlert = .updateBalance(action: viewModel.saveBalance)
                }
                .gesture(
                    DragGesture()
                        .onChanged {
                            let xTranslation = $0.translation.width
                            if xTranslation < 0 {
                                drag = xTranslation
                            }
                        }.onEnded {
                            let xTranslation = $0.translation.width
                            if xTranslation < -100 {
                                withAnimation {
                                    swipe()
                                    drag = 0
                                }
                            } else {
                                withAnimation {
                                    drag = 0
                                }
                            }
                        }
                ).animation(.default)
                                
                if viewModel.showOnboarding {
                    OnboardingTipView()
                } else {
                    RoundedButton(
                        title: Text("Swipe"),
                        titleColor: .white,
                        background: Color("ProminentContainerBackground"),
                        padding: .standard,
                        action: swipe
                    )
                }
                
                MetroCardActionGrid(
                    textAlert: $textAlert,
                    isShowingDatePicker: $isShowingDatePicker
                )
                
                Spacer()
            }.padding(.all, 20)
            .background(BackgroundView())
            .zIndex(0)
            
            if isShowingDatePicker {
                ModalSheet(isPresented: $isShowingDatePicker) {
                    DatePickerSheet(
                        initialValue: viewModel.data.source.expirationDate,
                        isPresented: $isShowingDatePicker,
                        saveHandler: { viewModel.perform(update: .expirationDate($0)) },
                        resetHandler: { viewModel.perform(update: .expirationDate(nil)) }
                    )
                }.transition(.opacity)
                .zIndex(1)
            }
        }
        .textAlert(item: $textAlert)
        .alert(item: $viewModel.error, content: { errorMessage in
            Alert(title: Text(errorMessage.title))
        }).onReceive(viewModel.tooltip, perform: toastQueue.displayToast)
        .onReceive(viewModel.completedTasks) {
            switch $0 {
            case .success:
                haptics.success()
            case .failure:
                haptics.failure()
            }
        }
    }
    
        
    func swipe() {
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
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView(cardData: MetroCardData())
//    }
//}

extension View {
    func eraseToAnyView() -> AnyView {
        return AnyView(self)
    }
}
