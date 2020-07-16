import Foundation
import SwiftUI

extension Font {
    static var cardBalance: Font {
        Font.system(size: 50, weight: .bold, design: .rounded)
            .monospacedDigit()
    }
    
    static var screenTitle: Font {
        Font.largeTitle
            .bold()
    }
    
    static var sheetTitle: Font {
        Font.title
            .bold()
    }
    
    static var contentCardTitle: Font {
        Font.headline.bold()
    }
    
    static var cardActionTitle: Font {
        Font.caption
            .weight(.medium)
            .uppercaseSmallCaps()
    }
    
    static var buttonTitle: Font {
        Font.body
            .weight(.semibold)
    }
    
    static var toastText: Font {
        Font.system(size: 17, weight: .semibold, design: .monospaced)
            .weight(.semibold)
    }
}
