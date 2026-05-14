//
//  DashboardView.swift
//  Scene
//
//  Created by Yousra Abdelrahman on 24/11/1447 AH.
//

import SwiftUI
// MARK: - Dashboard

struct DashboardView: View {
    
    let cards: [DashboardCard]
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                
                Text("Dashboard")
                    .font(.largeTitle.bold())
                
                LazyVGrid(columns: columns, spacing: 24) {
                    ForEach(cards) { card in
                        DashboardCardView(card: card)
                    }
                }
            }
            .padding(32)
        }
        .background(
            Color(nsColor: .windowBackgroundColor)
        )
    }
}
