//
//  AppState.swift
//  Scene
//
import SwiftUI
import Combine

final class AppState: ObservableObject {
    @Published var currentRoute: AppRoute = .onboarding
    @Published var isFirstLaunch: Bool = true
    @Published var currentUserID: UUID?
}

extension AppState {
    
    func navigate(to route: AppRoute) {
        currentRoute = route
    }
    
    func replace(with route: AppRoute) {
        currentRoute = route
    }
}

extension AppState {
    
    func start() {
        
        if isFirstLaunch {
            replace(with: .onboarding)
            return
        }
        
        replace(with: .home)
    }
}
