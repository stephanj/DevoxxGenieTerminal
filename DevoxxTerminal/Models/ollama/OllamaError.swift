import Foundation

enum OllamaError: LocalizedError {
    case invalidResponse
    case noCommandsReturned
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid response format from Ollama"
        case .noCommandsReturned:
            return "No commands were returned from Ollama"
        }
    }
}
