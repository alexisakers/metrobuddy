import SwiftUI

#warning("TODO: Finish error screen")
struct ErrorScreen: View {
    let error: AppError
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .component(.sheetTitle)

            Text("Unexpected Issue")
                .component(.cardTitle)
            
            Text(error.localizedDescription)
        }.padding(16)
        .edgesIgnoringSafeArea(.all)
        .background(BackgroundView())
    }
}
