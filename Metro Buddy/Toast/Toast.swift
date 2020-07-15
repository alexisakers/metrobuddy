import SwiftUI

/// A view that displays a toast; a short message that is displayed from the top of the screen
/// to temporarily draw the user's attention. Think of it as a message that would be displayed on
/// the turnstile when the user swipes their card.
struct Toast: View {
    let text: String
    
    var body: some View {
        Text(text)
            .foregroundColor(Color(.systemTeal))
            .component(.tooltip)
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(Color.black)
            .mask(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(radius: 8)
    }
}

// MARK: - Preview

struct Toast_Previews: PreviewProvider {
    static var previews: some View {
        Toast(text: "TEST TOAST")
    }
}
