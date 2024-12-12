import SwiftUI

struct ConsoleView: View {
    @ObservedObject var terminalViewModel: TerminalViewModel
    @State private var inputText = ""
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 0) {
            // Output area
            ScrollView {
                ScrollViewReader { proxy in
                    LazyVStack(alignment: .leading, spacing: 4) {
                        ForEach(terminalViewModel.output) { output in
                            Text(output.content)
                                .font(.system(size: 12, design: .monospaced))
                                .foregroundColor(color(for: output.type))
                                .textSelection(.enabled)
                                .padding(.horizontal, 12)
                                .id(output.id)
                        }
                    }
                    .padding(.vertical, 12)
                    .onChange(of: terminalViewModel.output) { output in
                        if !output.isEmpty {
                            withAnimation {
                                proxy.scrollTo(output.last?.id, anchor: .bottom)
                            }
                        }
                    }
                }
            }
            
            // Input area
            HStack(spacing: 8) {
                Text("$")
                    .font(.system(size: 12, design: .monospaced))
                    .foregroundColor(themeManager.currentTheme.secondaryTextColor)
                
                TextField("Enter command", text: $inputText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(.system(size: 12, design: .monospaced))
                    .foregroundColor(themeManager.currentTheme.textColor)
                    .onSubmit {
                        handleSubmit()
                    }
            }
            .padding(12)
            .background(themeManager.currentTheme.inputBackground)
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(themeManager.currentTheme.borderColor),
                alignment: .top
            )
        }
    }
    
    private func color(for outputType: TerminalOutput.OutputType) -> Color {
        switch outputType {
        case .input:
            return themeManager.currentTheme.textColor
        case .command:
            return Color.blue
        case .output:
            return themeManager.currentTheme.textColor
        case .error:
            return Color.red
        }
    }
    
    private func handleSubmit() {
        guard !inputText.isEmpty else { return }
        
        let originalInput = inputText
        inputText = "" // Clear input immediately
        
        if isDirectCommand(originalInput) {
            // For direct shell commands, execute immediately
            terminalViewModel.executeShellCommand(originalInput)
        } else {
            // For AI commands, get the command and execute it
            Task {
                do {
                    let suggestions = try await terminalViewModel.getSuggestions(for: originalInput)
                    if let firstSuggestion = suggestions.first {
                        // Execute the suggested command
                        terminalViewModel.executeShellCommand(firstSuggestion.command)
                    } else {
                        // If no suggestions, fall back to AI command
                        await terminalViewModel.executeAICommand(originalInput)
                    }
                } catch {
                    // If suggestion fails, fall back to AI command
                    await terminalViewModel.executeAICommand(originalInput)
                }
            }
        }
    }
    
    private func isDirectCommand(_ input: String) -> Bool {
        let shellCommands = ["ls", "cd", "pwd", "cp", "mv", "rm", "mkdir", "touch", "cat", "grep", "find", "chmod", "chown", "sudo"]
        let shellOperators = ["|", ">", ">>", "<", "&&", "||", ";"]
        
        let words = input.split(separator: " ")
        guard let firstWord = words.first else { return false }
        
        return shellCommands.contains(String(firstWord)) ||
               shellOperators.contains { input.contains($0) }
    }
}
