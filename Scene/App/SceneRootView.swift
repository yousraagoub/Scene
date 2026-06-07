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
            HomeView()
        }
    }
}
