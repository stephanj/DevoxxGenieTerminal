import Foundation

struct CommandSuggestion: Identifiable {
    let id = UUID()
    let command: String
    let description: String
}
