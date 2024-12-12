import SwiftUI

@main
struct DevoxxTerminalApp: App {
    @StateObject private var themeManager = ThemeManager()
    
    var body: some Scene {
        WindowGroup("DevoxxGenie Terminal") {
            MainView()
                .environmentObject(themeManager)
                .frame(minWidth: 600, minHeight: 400)
                .background(themeManager.currentTheme.background)
        }
        .windowStyle(.titleBar)  // Changed from .hiddenTitleBar to .titleBar
        .windowResizability(.contentSize)
        .defaultPosition(.center)
        .defaultSize(width: 800, height: 600)
        .commands {
            CommandGroup(replacing: .newItem) {
                Button("New Tab") {
                    // Add new tab functionality
                }
                .keyboardShortcut("t", modifiers: .command)
            }
            
            CommandGroup(replacing: .windowSize) {}  // Remove window size menu items
        }
    }
}
