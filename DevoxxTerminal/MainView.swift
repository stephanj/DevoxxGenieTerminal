import SwiftUI

struct MainView: View {
    @StateObject private var tabManager = TabManager()
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var showDebugPanel = false
       
    var body: some View {
        VStack(spacing: 0) {
            // Toolbar
            HStack {
                Button(action: { tabManager.addTab() }) {
                    Image(systemName: "plus")
                        .font(.system(size: 12, weight: .medium))
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal, 8)
                
                Button(action: { themeManager.toggleTheme() }) {
                    Image(systemName: themeManager.isDarkMode ? "sun.max" : "moon")
                        .font(.system(size: 12, weight: .medium))
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal, 8)
                
                Button(action: { showDebugPanel.toggle() }) {
                    Image(systemName: "terminal")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(showDebugPanel ? themeManager.currentTheme.accentColor : nil)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal, 8)
                
                Spacer()
            }
            .padding(8)
            .background(themeManager.currentTheme.toolbarBackground)
            
            // Tab Bar
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 2) {
                    ForEach(tabManager.tabs) { tab in
                        TabView(tab: tab, isSelected: tabManager.selectedTabId == tab.id) {
                            tabManager.selectTab(tab)
                        } onClose: {
                            tabManager.closeTab(tab)
                        }
                    }
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
            }
            .background(themeManager.currentTheme.tabBarBackground)
            
            // Content Area
            if let selectedTab = tabManager.selectedTab {
                ConsoleView(terminalViewModel: selectedTab.terminalViewModel)
                    .id(selectedTab.id)
            }
            
            // Debug Panel
            if showDebugPanel {
                if let selectedTab = tabManager.selectedTab {
                    DebugPanelView(ollamaService: selectedTab.terminalViewModel.ollamaService)
                        .transition(.move(edge: .bottom))
                }
            }
        }
        .background(themeManager.currentTheme.background)
    }
}

#Preview {
    MainView()
        .environmentObject(ThemeManager())
}
