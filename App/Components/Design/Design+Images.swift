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

        static var checkmarkCircleFill: Image {
            Image(systemName: "checkmark.circle.fill")
        }

        static var plusCircleFill: Image {
            Image(systemName: "plus.circle.fill")
        }

        static var chevronRight: Image {
            Image(systemName: "chevron.right")
        }
    }
    
    enum Assets {
        static var metroCardArrows: Image {
            Image("MetroCardArrows")
        }

        static var siriButton: Image {
            Image("SiriButton")
        }
    }
}
