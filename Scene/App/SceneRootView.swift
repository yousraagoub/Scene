//
//  SceneRootView.swift
//  Scene
//
//  Created by Yousra Abdelrahman on 21/11/1447 AH.
//
import SwiftUI

struct SceneRootView: View {
    
    @EnvironmentObject private var appState: AppState
    
    var body: some View {
        
        NavigationStack(path: $appState.router.path) {
            
            rootView
                .navigationDestination(for: AppRoute.self) { route in
                    destination(for: route)
                }
        }
    }
}

// MARK: - Root View

extension SceneRootView {
    
    @ViewBuilder
    private var rootView: some View {
        
        switch appState.router.currentRoute {
            
        case .onboarding:
            Text("Onboarding View")
//            OnboardingView()
            
        case .auth:
            Text("Auth View")
//            AuthView()
            
        case .home:
            Text("Home View")
//            HomeView()
            
        case .projects:
            Text("Projects View")
//            ProjectsView()
            
        default:
            ContentView()
        }
    }
}

// MARK: - Destinations (Stack Navigation)
//
extension SceneRootView {

    @ViewBuilder
    private func destination(for route: AppRoute) -> some View {
        
        switch route {
            
        case .projects:
            Text("Projects View")
//            ProjectsView()
            
        case .analysis:
            Text("Analysis View")
            
        case .budget:
            Text("Budget View")
            
        case .highlightedScript:
            Text("Highlighted Script View")
            
        default:
            EmptyView()
        }
    }
}
