import SwiftUI

struct SuggestionsView: View {
    let suggestions: [CommandSuggestion]
    let onSelect: (String) -> Void
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(suggestions) { suggestion in
                HStack {
                    Text(suggestion.command)
                        .font(.system(.body, design: .monospaced))
                    Spacer()
                    Text(suggestion.description)
                        .font(.caption)
                        .foregroundColor(themeManager.currentTheme.secondaryTextColor)
                }
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                .background(themeManager.currentTheme.inputBackground)
                .cornerRadius(4)
                .onTapGesture {
                    onSelect(suggestion.command)
                }
            }
        }
        .padding(8)
        .background(themeManager.currentTheme.background)
        .cornerRadius(8)
        .shadow(radius: 2)
    }
}
