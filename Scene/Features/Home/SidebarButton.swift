//
// SidebarButton.swift
// Scene
//

import SwiftUI

struct SidebarButton: View {

    let item: SidebarItem
    let isSelected: Bool
    let compact: Bool
    let action: () -> Void

    var body: some View {

        Button(action: action) {
            HStack(spacing: 14) {

                Image(systemName: item.systemImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)

                if !compact {
                    Text(item.title)
                        .font(.title2)
                        
                }

                if !compact {
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity)
            .foregroundStyle(isSelected ? .white : .secondary)
            .padding()
        }
        .buttonStyle(.plain)
    }
}
