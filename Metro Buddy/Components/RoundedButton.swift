import SwiftUI
import UIKit
import AudioToolbox

enum Title {
    case string(String)
    case localizedString(LocalizedStringKey)
}

struct RoundedButton<Background: View>: View {
    let title: Text
    let titleColor: Color
    let background: Background
    let padding: Padding
    let action: () -> Void

    init(title: Text, titleColor: Color, background: Background, padding: Padding, action: @escaping () -> Void) {
        self.title = title
        self.titleColor = titleColor
        self.background = background
        self.padding = padding
        self.action = action
    }
        
    var body: some View {
        Button(action: action, label: {
            HStack {
                Spacer()
                
                title
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(titleColor)
            
                Spacer()
            }.padding(padding)
            .background(background)
            .mask(RoundedRectangle(cornerRadius: 20, style: .continuous))
        }).buttonStyle(ScaleButtonStyle())
    }
}

struct ScaleButtonStyle: ButtonStyle {
    static let animationDuration = 0.1
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(.accentColor)
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(.easeInOut(duration: Self.animationDuration))
    }
}

enum Padding {
    case standard
    case compact
}

struct PaddingModifier: ViewModifier {
    let padding: Padding
    
    func body(content: Content) -> some View {
        switch padding {
        case .compact:
            return content
                .padding(10)
        case .standard:
            return content
                .padding(20)
        }
    }
}

extension View {
    func padding(_ padding: Padding) -> some View {
        modifier(PaddingModifier(padding: padding))
    }
}
