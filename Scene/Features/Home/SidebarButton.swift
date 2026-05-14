//
//  SidebarButton.swift
//  Scene
//
import SwiftUI

struct SidebarButton: View {
    
    let item: SidebarItem
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                
                Image(systemName: item.systemImage)
                    .font(.system(size: 16, weight: .semibold))
                
                Text(item.title)
                    .font(.system(size: 15, weight: .medium))
                
                Spacer()
            }
            .foregroundStyle(isSelected ? .white : .primaryRed)
            .padding(.vertical, 12)
            .padding(.horizontal, 14)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(isSelected ? Color.primaryRed : Color.clear)
            )
        }
        .buttonStyle(.plain)
    }
}
