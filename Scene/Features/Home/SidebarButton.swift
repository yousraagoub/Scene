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
                    .font(
                        .system(
                            size: 16,
                            weight: .semibold
                        )
                    )

                if !compact {

                    Text(item.title)
                        .font(
                            .system(
                                size: 15,
                                weight: .medium
                            )
                        )
                }

                if !compact {
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity)
            .foregroundStyle(
                isSelected
                ? .black
                : .white
            )
            .padding(.vertical,12)
            .padding(.horizontal,14)
            .background(
                RoundedRectangle(
                    cornerRadius:14
                )
                .fill(
                    isSelected
                    ? Color.white
                    : Color.clear
                )
            )
        }
        .buttonStyle(.plain)
    }
}
