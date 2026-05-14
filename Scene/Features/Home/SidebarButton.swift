//
//  SidebarButton.swift
//  Scene
//
//  Created by Yousra Abdelrahman on 24/11/1447 AH.
//
import SwiftUI
// MARK: - Sidebar Button

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
            .foregroundStyle(isSelected ? .white : .red)
            .padding(.vertical, 12)
            .padding(.horizontal, 14)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(isSelected ? Color.red : Color.clear)
            )
        }
        .buttonStyle(.plain)
    }
}
