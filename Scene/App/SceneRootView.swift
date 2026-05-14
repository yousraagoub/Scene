//
//  SceneRootView.swift
//  Scene
//
import SwiftUI

struct SceneRootView: View {
    
    @EnvironmentObject private var appState: AppState
    
    var body: some View {
        
        rootView
            .animation(.easeInOut(duration: 0.2), value: appState.currentRoute)
    }
}

// MARK: - Root View

extension SceneRootView {
    
    @ViewBuilder
    private var rootView: some View {
        
        switch appState.currentRoute {
            
        case .onboarding:
            BackgroundView {
                OnboardingView()
            }
            
        case .home:
            BackgroundView{
                HomeView()
            }
            
        case .projects:
            Text("Projects View")
            
        case .createProject:
            BackgroundView {
                CreateProjectView()
            }
            
        case .analysis:
            Text("Analysis View")
            
        case .budget:
            Text("Budget View")
            
        case .highlightedScript:
            Text("Highlighted Script View")
            
        case .projectDetails:
            Text("Project Details")
        }
    }
}
