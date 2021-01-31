import SwiftUI

struct PartialRoundedRectangle: Shape {
    let roundedCorners: UIRectCorner
    let cornerRadius: CGFloat

    func path(in rect: CGRect) -> Path {
        Path(
            UIBezierPath(
                roundedRect: rect,
                byRoundingCorners: roundedCorners,
                cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
            )
            .cgPath
        )
    }
}
