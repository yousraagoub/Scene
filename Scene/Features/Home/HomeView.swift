//
//  HomeView.swift
//  Scene
//
//  Created by Yousra Abdelrahman on 19/11/1447 AH.
//
//
import SwiftUI

struct HomeView: View {
    
    @StateObject private var homeVM = HomeViewModel()
    
    var body: some View {
        NavigationSplitView {
            SidebarView(homeVM: homeVM)
                .navigationSplitViewColumnWidth(
                    //smallest allowed width
                    min: 260,
                    //preferred startup width
                    ideal: 280,
                    max: 320
                )
        } detail: {
            DashboardView(cards: homeVM.dashboardCards)
        }
        .navigationTitle("Home")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationSplitViewStyle(.balanced)
        
    }
}


// MARK: - Preview

#Preview {
    let settings = AppSettings()
    let appState = AppState()
    
    return HomeView()
        .environmentObject(settings)
        .environmentObject(appState)
}
