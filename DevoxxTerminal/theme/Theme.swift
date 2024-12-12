import SwiftUI

struct Theme {
    let background: Color
    let toolbarBackground: Color
    let tabBarBackground: Color
    let inputBackground: Color
    let textColor: Color
    let secondaryTextColor: Color
    let accentColor: Color
    let borderColor: Color
    
    static let light = Theme(
        background: Color.white,
        toolbarBackground: Color(nsColor: NSColor(red: 0.92, green: 0.92, blue: 0.93, alpha: 1.0)),
        tabBarBackground: Color(nsColor: NSColor(red: 0.92, green: 0.92, blue: 0.93, alpha: 1.0)),
        inputBackground: Color(nsColor: NSColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.0)),
        textColor: Color(nsColor: NSColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)),
        secondaryTextColor: Color(nsColor: NSColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)),
        accentColor: Color.blue,
        borderColor: Color(nsColor: NSColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0))
    )
    
    static let dark = Theme(
        background: Color(nsColor: NSColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0)),
        toolbarBackground: Color(nsColor: NSColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)),
        tabBarBackground: Color(nsColor: NSColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)),
        inputBackground: Color(nsColor: NSColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1.0)),
        textColor: Color.white,
        secondaryTextColor: Color(nsColor: NSColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0)),
        accentColor: Color.blue,
        borderColor: Color(nsColor: NSColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0))
    )
}
