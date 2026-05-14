//
//  HomeView.swift
//  Scene
//
import SwiftUI

struct HomeView: View {
    
    @StateObject private var homeVM = HomeViewModel()
    
    var body: some View {
        
        NavigationSplitView {
            
            SidebarView(homeVM: homeVM)
                .navigationSplitViewColumnWidth(
                    min: 260,
                    ideal: 280,
                    max: 320
                )
            
        } detail: {
            
            detailView
        }
        .navigationTitle("Home")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationSplitViewStyle(.balanced)
    }
}

extension HomeView {
    
    @ViewBuilder
    private var detailView: some View {
        
        switch homeVM.selectedSection {
            
        case .home:
            BackgroundView {
                HomeLandingView(homeVM: homeVM)
            }
            
        case .createProject:
            CreateProjectView()
            
        case .projects:
            Text("Projects View")
            
        case .analysis:
            Text("Analysis View")
        }
    }
}
