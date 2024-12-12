import Foundation

struct OllamaLog: Identifiable, Equatable {
    let id = UUID()
    let timestamp: Date
    let type: LogType
    let content: String
    
    enum LogType: Equatable {
        case request
        case response
        case error
    }
    
    // Implement Equatable
    static func == (lhs: OllamaLog, rhs: OllamaLog) -> Bool {
        lhs.id == rhs.id &&
        lhs.timestamp == rhs.timestamp &&
        lhs.type == rhs.type &&
        lhs.content == rhs.content
    }
}
