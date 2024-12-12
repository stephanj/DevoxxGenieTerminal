import SwiftUI

struct TabView: View {
    let tab: TabData
    let isSelected: Bool
    let onSelect: () -> Void
    let onClose: () -> Void
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        HStack(spacing: 8) {
            Text(tab.title)
                .lineLimit(1)
                .font(.system(size: 12))
            
            Button(action: onClose) {
                Image(systemName: "xmark")
                    .font(.system(size: 9, weight: .medium))
                    .foregroundColor(themeManager.currentTheme.secondaryTextColor)
            }
            .buttonStyle(PlainButtonStyle())
            .opacity(isSelected ? 1 : 0)
            .frame(width: 16, height: 16)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(isSelected ? themeManager.currentTheme.background : themeManager.currentTheme.tabBarBackground)
        .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .stroke(isSelected ? themeManager.currentTheme.borderColor : Color.clear, lineWidth: 0.5)
        )
        .onTapGesture(perform: onSelect)
    }
}
