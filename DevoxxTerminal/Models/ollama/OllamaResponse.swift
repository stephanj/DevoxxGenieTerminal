import Foundation

struct OllamaResponse: Codable {
    let response: String
    let context: [Int]?
    let created_at: String?
    let total_duration: Int?
    let load_duration: Int?
    let prompt_eval_count: Int?
    let prompt_eval_duration: Int?
    let eval_count: Int?
    let eval_duration: Int?
    
    func parseCommandResponse() throws -> CommandResponse {
        guard let data = response.data(using: .utf8) else {
            throw OllamaError.invalidResponse
        }
        
        return try JSONDecoder().decode(CommandResponse.self, from: data)
    }
}
