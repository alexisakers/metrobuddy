import SwiftUI

extension Color {
    static var metroCardYellow: Color {
        Color("MetroCardYellow")
    }
    
    static var metroCardOrange: Color {
        Color("MetroCardOrange")
    }
    
    static var contentBackground: Color {
        Color("BackgroundColor")
    }
    
    static var prominentContainerBackground: Color {
        Color("ProminentContainerBackground")
    }

    static var siriPurple: Color {
        Color("SiriPurple")
    }

    static var toastText: Color {
        Color(.systemTeal)
    }
}

extension UIColor {
    static var contentBackground: UIColor {
        UIColor(named: "BackgroundColor")!
    }
}
