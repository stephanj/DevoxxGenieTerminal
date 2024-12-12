import SwiftUI

struct CommandInputView: View {
    @Binding var inputText: String
    @State private var suggestionText: String = ""
    @State private var showSuggestion = false
    let onSubmit: () -> Void
    let onTab: () -> Void
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        HStack(spacing: 8) {
            Text("$")
                .font(.system(size: 12, design: .monospaced))
                .foregroundColor(themeManager.currentTheme.secondaryTextColor)
            
            ZStack(alignment: .leading) {
                if showSuggestion, !suggestionText.isEmpty {
                    HStack {
                        Text(inputText)
                            .font(.system(size: 12, design: .monospaced))
                            .foregroundColor(.clear)
                            .background(
                                Text(suggestionText)
                                    .font(.system(size: 12, design: .monospaced))
                                    .foregroundColor(themeManager.currentTheme.secondaryTextColor.opacity(0.5))
                            )
                        
                        Image(systemName: "tab")
                            .font(.system(size: 10))
                            .foregroundColor(themeManager.currentTheme.secondaryTextColor)
                    }
                }
                
                TextField("Enter command", text: $inputText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(.system(size: 12, design: .monospaced))
                    .foregroundColor(themeManager.currentTheme.textColor)
                    .onSubmit(onSubmit)
                    .onChange(of: inputText) { _ in
                        updateSuggestion()
                    }
                    .onKeyPress(.tab) {
                        onTab()
                        return .handled
                    }
            }
        }
        .padding(12)
        .background(themeManager.currentTheme.inputBackground)
    }
    
    private func updateSuggestion() {
        // Update suggestion logic here
        showSuggestion = !inputText.isEmpty
    }
}
