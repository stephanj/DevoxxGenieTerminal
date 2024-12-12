import Foundation

@MainActor
class TerminalViewModel: ObservableObject {
    @Published private(set) var output: [TerminalOutput] = []
    @Published private(set) var currentDirectory: URL
    @Published var currentSuggestion: String?
     
    let ollamaService: OllamaService
    private let shell = Shell()
    
    init() {
        self.ollamaService = OllamaService()
        let homeURL = URL(fileURLWithPath: NSHomeDirectory())
        do {
            try homeURL.startAccessingSecurityScopedResource()
        } catch {
            print("Failed to get file access permission: \(error)")
        }
        
        self.currentDirectory = homeURL
    }
    
    func executeShellCommand(_ command: String) {
        let trimmedCommand = command.trimmingCharacters(in: .whitespacesAndNewlines)
        
        output.append(TerminalOutput(content: trimmedCommand, type: .command))
        
        Task {
            do {
                if trimmedCommand.starts(with: "cd") {
                    try await handleChangeDirectory(trimmedCommand)
                } else {
                    let result = try await shell.execute(trimmedCommand, currentDirectory: currentDirectory)
                    if !result.isEmpty {
                        output.append(TerminalOutput(content: result.trimmingCharacters(in: .newlines), type: .output))
                    }
                }
            } catch {
                output.append(TerminalOutput(content: error.localizedDescription, type: .error))
            }
        }
    }
    
    private func handleChangeDirectory(_ command: String) async throws {
        let components = command.split(separator: " ")
        guard components.count == 2 else {
            throw ShellError.commandFailed(command: command, status: 1, output: "cd: wrong number of arguments")
        }
        
        let targetPath = String(components[1])
        let targetURL: URL
        
        if targetPath == "~" || targetPath.hasPrefix("~/") {
            if let home = ProcessInfo.processInfo.environment["HOME"] {
                let expandedPath = targetPath.replacingOccurrences(of: "~", with: home)
                targetURL = URL(fileURLWithPath: expandedPath)
            } else {
                throw ShellError.commandFailed(command: command, status: 1, output: "Unable to resolve home directory")
            }
        } else if targetPath == ".." {
            targetURL = currentDirectory.deletingLastPathComponent()
        } else if targetPath.hasPrefix("/") {
            targetURL = URL(fileURLWithPath: targetPath)
        } else {
            targetURL = currentDirectory.appendingPathComponent(targetPath)
        }
        
        var isDirectory: ObjCBool = false
        guard FileManager.default.fileExists(atPath: targetURL.path, isDirectory: &isDirectory),
              isDirectory.boolValue else {
            throw ShellError.commandFailed(command: command, status: 1, output: "cd: no such directory: \(targetPath)")
        }
        
        currentDirectory = targetURL
        output.append(TerminalOutput(content: "Changed directory to: \(targetURL.path)", type: .output))
    }
    
    func executeAICommand(_ command: String) async {
        output.append(TerminalOutput(content: command, type: .command))
        
        do {
            let suggestions = try await ollamaService.getSuggestions(for: command)
            if let suggestion = suggestions.first {
                executeShellCommand(suggestion.command)
            } else {
                let chatResponse = try await ollamaService.chat(message: command)
                output.append(TerminalOutput(content: chatResponse, type: .output))
            }
        } catch {
            output.append(TerminalOutput(content: error.localizedDescription, type: .error))
        }
    }
    
    func getSuggestions(for input: String) async throws -> [CommandSuggestion] {
        let prompt = "Give me a unix command which results in what the user requests: '\(input)'Only return the unix command nothing else."
        return try await ollamaService.getSuggestions(for: prompt)
    }
}
