import SwiftUI

public extension Image {
    enum Symbols {
        public static var lightbulb: Image {
            Image(systemName: "lightbulb")
        }
        
        public static var exclamationMarkTriangleFill: Image {
            Image(systemName: "exclamationmark.triangle.fill")
        }
        
        public static var closeButton: Image {
            Image(systemName: "xmark.circle.fill")
        }

        public static var checkmarkCircleFill: Image {
            Image(systemName: "checkmark.circle.fill")
        }

        public static var plusCircleFill: Image {
            Image(systemName: "plus.circle.fill")
        }

        public static var chevronRight: Image {
            Image(systemName: "chevron.right")
        }
    }
    
    enum Assets {
        public static var metroCardArrows: Image {
            Image("MetroCardArrows", bundle: .metroUI)
        }

        public static var siriButton: Image {
            Image("SiriButton", bundle: .metroUI)
        }
    }
}
