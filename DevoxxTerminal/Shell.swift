import Foundation

class Shell {
    private func expandTilde(_ command: String) -> String {
            if let home = ProcessInfo.processInfo.environment["HOME"] {
                return command.replacingOccurrences(of: "~/", with: "\(home)/")
            }
            return command
        }
        
    
    func execute(_ command: String, currentDirectory: URL) async throws -> String {
            let expandedCommand = expandTilde(command)
            let process = Process()
            let pipe = Pipe()
            
            // Configure process
            process.executableURL = URL(fileURLWithPath: "/bin/zsh")
            process.arguments = ["-l", "-c", expandedCommand]
            process.standardOutput = pipe
            process.standardError = pipe
            
            process.currentDirectoryURL = currentDirectory
            
            // Setup environment including HOME
            var environment = ProcessInfo.processInfo.environment
            environment["PATH"] = "/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
            if let home = ProcessInfo.processInfo.environment["HOME"] {
                environment["HOME"] = home
            }
            process.environment = environment
         
        return try await withCheckedThrowingContinuation { continuation in
            var outputData = Data()

            pipe.fileHandleForReading.readabilityHandler = { handle in
                let data = handle.availableData
                if data.isEmpty {
                    pipe.fileHandleForReading.readabilityHandler = nil
                    process.waitUntilExit()

                    if process.terminationStatus != 0 {
                        continuation.resume(throwing: ShellError.commandFailed(
                            command: command,
                            status: process.terminationStatus,
                            output: String(data: outputData, encoding: .utf8) ?? ""
                        ))
                    } else {
                        continuation.resume(returning: String(data: outputData, encoding: .utf8) ?? "")
                    }
                } else {
                    outputData.append(data)
                }
            }

            do {
                try process.run()
            } catch {
                continuation.resume(throwing: ShellError.executionFailed(error))
            }
        }
    }
}

enum ShellError: LocalizedError {
    case commandFailed(command: String, status: Int32, output: String)
    case executionFailed(Error)

    var errorDescription: String? {
        switch self {
        case .commandFailed(let command, let status, let output):
            return "Command '\(command)' failed with status \(status): \(output)"
        case .executionFailed(let error):
            return "Failed to execute command: \(error.localizedDescription)"
        }
    }
}
