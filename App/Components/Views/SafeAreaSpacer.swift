import SwiftUI

/// A spacer whose min length is set to the safe area insets of the specified edge.
struct SafeAreaSpacer: View {
    let edge: Edge

    var body: some View {
        GeometryReader { geometry in
            Spacer(minLength: geometry.safeAreaInsets[self.edge])
        }.fixedSize(horizontal: false, vertical: true)
    }
}

// MARK: - Helpers

extension EdgeInsets {
    /// Returns the value of the insets for the specified edge.
    subscript(edge: Edge) -> CGFloat {
        switch edge {
        case .top:
            return top
        case .trailing:
            return trailing
        case .bottom:
            return bottom
        case .leading:
            return leading
        }
    }
}
