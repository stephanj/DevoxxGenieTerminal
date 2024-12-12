import Foundation
import Combine

@MainActor
class OllamaService: ObservableObject {
    private let baseURL = "http://localhost:11434"
    private let model = "llama3.2"
    
    @Published private(set) var logs: [OllamaLog] = []
    
    // JSON Schema for command format
    private let commandSchema: [String: Any] = [
        "type": "object",
        "properties": [
            "command": [
                "type": "string",
                "description": "The shell command to execute"
            ]
        ],
        "required": ["command"]
    ]
    
    func getLogs() -> [OllamaLog] {
        return logs
    }
    
    func addLog(_ log: OllamaLog) {
        logs.append(log)
    }
    
    func chat(message: String) async throws -> String {
        let payload: [String: Any] = [
            "model": model,
            "messages": [
                ["role": "system", "content": "You are a unix shell terminal service which returns the correct MacOS commands for the given user description"],
                ["role": "user", "content": message]
            ],
            "format": commandSchema,
            "stream": false
        ]
        
        addLog(OllamaLog(timestamp: Date(), type: .request, content: "Chat message: \(message)"))
        
        guard let url = URL(string: "\(baseURL)/api/chat") else {
            let error = "Invalid URL: \(baseURL)/api/chat"
            addLog(OllamaLog(timestamp: Date(), type: .error, content: error))
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let response = try JSONDecoder().decode(ChatResponse.self, from: data)
            let content = response.message.content
            addLog(OllamaLog(timestamp: Date(), type: .response, content: content))
            
            // Parse the JSON string response to extract command
            if let jsonData = content.data(using: .utf8),
               let json = try? JSONSerialization.jsonObject(with: jsonData) as? [String: String],
               let command = json["command"] {
                return command
            } else {
                throw OllamaError.invalidResponse
            }
        } catch {
            addLog(OllamaLog(timestamp: Date(), type: .error, content: error.localizedDescription))
            throw error
        }
    }
    
    func getSuggestions(for input: String) async throws -> [CommandSuggestion] {
        let prompt = "Give me a unix command which results in what the user requests: '\(input)' Return only the command in JSON format"
        
        let payload: [String: Any] = [
            "model": model,
            "prompt": prompt,
            "format": commandSchema,
            "stream": false
        ]
        
        addLog(OllamaLog(timestamp: Date(), type: .request, content: "Prompt: \(prompt)"))
        
        guard let url = URL(string: "\(baseURL)/api/generate") else {
            let error = "Invalid URL: \(baseURL)/api/generate"
            addLog(OllamaLog(timestamp: Date(), type: .error, content: error))
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let ollamaResponse = try JSONDecoder().decode(OllamaResponse.self, from: data)
            addLog(OllamaLog(timestamp: Date(), type: .response, content: ollamaResponse.response))
            
            // Parse the JSON string response to extract command
            if let jsonData = ollamaResponse.response.data(using: .utf8),
               let json = try? JSONSerialization.jsonObject(with: jsonData) as? [String: String],
               let command = json["command"] {
                return [CommandSuggestion(command: command, description: "Generated command")]
            } else {
                throw OllamaError.noCommandsReturned
            }
        } catch {
            addLog(OllamaLog(timestamp: Date(), type: .error, content: error.localizedDescription))
            throw error
        }
    }
}
