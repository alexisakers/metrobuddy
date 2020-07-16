import SwiftUI

extension Image {
    enum Symbols {
        static var lightbulb: Image {
            Image(systemName: "lightbulb")
        }
        
        static var exclamationMarkTriangleFill: Image {
            Image(systemName: "exclamationmark.triangle.fill")
        }
        
        static var closeButton: Image {
            Image(systemName: "xmark.circle.fill")
        }
    }
    
    enum Assets {
        static var metroCardArrows: Image {
            Image("MetroCardArrows")
        }
    }
}
