import Foundation

struct TerminalOutput: Identifiable, Equatable {
    let id = UUID()
    let content: String
    let type: OutputType
    
    enum OutputType: Equatable {  // Also make the enum Equatable
        case input
        case command
        case output
        case error
    }
    
    // Implement Equatable
    static func == (lhs: TerminalOutput, rhs: TerminalOutput) -> Bool {
        lhs.id == rhs.id &&
        lhs.content == rhs.content &&
        lhs.type == rhs.type
    }
}
