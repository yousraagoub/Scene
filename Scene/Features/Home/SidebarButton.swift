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
            HStack{
                Image(systemName: item.systemImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 22)

                if !compact {
                    Text(item.title)
                        .font(.title2)
                        .fontWeight(.medium)
                }

                if !compact {
                    Spacer()
                }
            }
            .foregroundStyle(isSelected ? .black : .white)
            .padding(10)
            .background(RoundedRectangle(cornerRadius:50)
            .fill(isSelected ? Color.white : Color.clear))
        }
        .buttonStyle(.plain)
    }
}
