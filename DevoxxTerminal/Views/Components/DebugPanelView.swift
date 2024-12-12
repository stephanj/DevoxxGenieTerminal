import SwiftUI

struct DebugPanelView: View {
    @ObservedObject var ollamaService: OllamaService
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            titleSection
            logsSection
        }
        .padding()
        .frame(height: 200)
        .background(themeManager.currentTheme.background)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(themeManager.currentTheme.borderColor),
            alignment: .top
        )
    }
    
    private var titleSection: some View {
        Text("Ollama Debug Logs")
            .font(.headline)
            .padding(.bottom, 4)
    }
    
    private var logsSection: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 8) {
                    ForEach(ollamaService.logs) { log in
                        LogEntryView(log: log)
                            .id(log.id)
                    }
                }
                .onChange(of: ollamaService.logs) { _, _ in
                    scrollToLatestLog(proxy: proxy)
                }
            }
        }
    }
    
    private func scrollToLatestLog(proxy: ScrollViewProxy) {
        if let lastLog = ollamaService.logs.last {
            withAnimation {
                proxy.scrollTo(lastLog.id, anchor: .bottom)
            }
        }
    }
}

struct LogEntryView: View {
    let log: OllamaLog
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Circle()
                    .fill(logColor(for: log.type))
                    .frame(width: 8, height: 8)
                
                Text(log.timestamp, style: .time)
                    .font(.caption)
                
                Text(String(describing: log.type))
                    .font(.caption)
                    .foregroundColor(themeManager.currentTheme.secondaryTextColor)
            }
            
            Text(log.content)
                .font(.system(.caption, design: .monospaced))
                .foregroundColor(themeManager.currentTheme.textColor)
                .textSelection(.enabled)
        }
        .padding(8)
        .background(themeManager.currentTheme.inputBackground)
        .cornerRadius(6)
    }
    
    private func logColor(for type: OllamaLog.LogType) -> Color {
        switch type {
        case .request:
            return .blue
        case .response:
            return .green
        case .error:
            return .red
        }
    }
}

#Preview {
    DebugPanelView(ollamaService: OllamaService())
        .environmentObject(ThemeManager())
}
