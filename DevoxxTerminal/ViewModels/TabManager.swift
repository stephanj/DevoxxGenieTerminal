import Foundation

@MainActor
class TabManager: ObservableObject {
    @Published var tabs: [TabData] = []
    @Published var selectedTabId: UUID?
    
    var selectedTab: TabData? {
        tabs.first { $0.id == selectedTabId }
    }
    
    init() {
        addTab() // Create initial tab
    }
    
    func addTab() {
        let newTab = TabData(title: "Terminal \(tabs.count + 1)")
        tabs.append(newTab)
        selectedTabId = newTab.id
    }
    
    func closeTab(_ tab: TabData) {
        guard tabs.count > 1 else { return } // Keep at least one tab
        if let index = tabs.firstIndex(where: { $0.id == tab.id }) {
            tabs.remove(at: index)
            if selectedTabId == tab.id {
                selectedTabId = tabs[max(0, index - 1)].id
            }
        }
    }
    
    func selectTab(_ tab: TabData) {
        selectedTabId = tab.id
    }
}
