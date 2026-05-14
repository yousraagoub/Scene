//
//  DashboardCardView.swift
//  Scene
//
//  Created by Yousra Abdelrahman on 24/11/1447 AH.
//
import SwiftUI
// MARK: - Dashboard Card

struct DashboardCardView: View {
    
    let card: DashboardCard
    
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            
            HStack {
                Image(systemName: card.icon)
                    .font(.title2)
                    .foregroundStyle(.red)
                
                Spacer()
            }
            
            Spacer()
            
            Text(card.title)
                .font(.headline)
            
            if let value = card.value {
                Text(value)
                    .font(.system(size: 40, weight: .bold))
            } else {
                Text("Coming Soon")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
        }
        .padding(24)
        .frame(height: 220)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.background)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .strokeBorder(Color.gray.opacity(0.12))
        )
        .shadow(
            color: .black.opacity(0.04),
            radius: 10,
            y: 4
        )
    }
}
