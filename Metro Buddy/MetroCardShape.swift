import SwiftUI

/// A shape with a clipped corner that matches the design of a Metro Card.
struct MetroCardShape: Shape {
    func path(in rect: CGRect) -> Path {
        let leftRect = CGRect(x: 0, y: 0, width: rect.width / 2, height: rect.height)
        let bottomRightRect = CGRect(x: rect.midX, y: rect.midY, width: rect.width / 2, height: rect.height / 2)
        let cornerRadius = CGSize(width: 20, height: 20)
        
        var leftPath = Path(
            UIBezierPath(
                roundedRect: leftRect,
                byRoundingCorners: [.topLeft, .bottomLeft],
                cornerRadii: cornerRadius
            ).cgPath
        )
        
        let topRightPath = Path { path in
            let cornerSize = 0.1 * rect.width
            let topLeft = CGPoint(x: rect.midX, y: 0)
            let highCorner = CGPoint(x: rect.maxX - cornerSize, y: 0)
            let lowCorner = CGPoint(x: rect.maxX, y: cornerSize)
            let bottomRight = CGPoint(x: rect.maxX, y: rect.midY)
            let bottomLeft = CGPoint(x: rect.midX, y: rect.midY)

            
            path.move(to: topLeft)
            path.addLine(to: highCorner)
            path.addLine(to: lowCorner)
            path.addLine(to: bottomRight)
            path.addLine(to: bottomLeft)
            path.addLine(to: topLeft)
        }
        
        let bottomRightPath = Path(
            UIBezierPath(
                roundedRect: bottomRightRect,
                byRoundingCorners: .bottomRight,
                cornerRadii: cornerRadius
            ).cgPath
        )
        
        leftPath.addPath(topRightPath)
        leftPath.addPath(bottomRightPath)

        return leftPath
    }
}
