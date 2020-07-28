import SwiftUI

extension Color {
    public static var metroCardYellow: Color {
        Color("MetroCardYellow", bundle: .metroUI)
    }
    
    public static var metroCardOrange: Color {
        Color("MetroCardOrange", bundle: .metroUI)
    }
    
    public static var contentBackground: Color {
        Color("BackgroundColor", bundle: .metroUI)
    }
    
    public static var prominentContainerBackground: Color {
        Color("ProminentContainerBackground", bundle: .metroUI)
    }

    public static var siriPurple: Color {
        Color("SiriPurple", bundle: .metroUI)
    }

    public static var toastText: Color {
        Color(.systemTeal)
    }
}

extension UIColor {
    public static var contentBackground: UIColor {
        UIColor(named: "BackgroundColor", in: .metroUI, compatibleWith: nil)!
    }
}
