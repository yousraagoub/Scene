//
//  MenuActionButton.swift
//  Scene
//
//  Created by Yousra Abdelrahman on 24/11/1447 AH.
//
import SwiftUI
struct MenuActionButton: View {
    
    enum Role {
        case normal
        case destructive
    }
    
    let title: String
    let systemImage: String
    let role: Role
    let action: () -> Void
    
    var foregroundColor: Color {
        switch role {
        case .normal:
            return .primary
        case .destructive:
            return .red
        }
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                
                Image(systemName: systemImage)
                    .frame(width: 18)
                
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                
                Spacer()
            }
            .foregroundStyle(foregroundColor)
            .padding(.vertical, 10)
            .padding(.horizontal, 14)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.gray.opacity(0.06))
            )
        }
        .buttonStyle(.plain)
    }
}
