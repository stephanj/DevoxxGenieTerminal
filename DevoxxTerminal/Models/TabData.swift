import Foundation

@MainActor
struct TabData: Identifiable {
    let id = UUID()
    let title: String
    let terminalViewModel: TerminalViewModel
    
    init(title: String) {
        self.title = title
        self.terminalViewModel = TerminalViewModel()
    }
}
