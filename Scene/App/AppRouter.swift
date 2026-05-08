//
//  AppRouter.swift
//  Scene
//
//  Created by Yousra Abdelrahman on 19/11/1447 AH.
//
import SwiftUI
import Combine
final class AppRouter: ObservableObject {
    
    // Current root screen
    @Published var currentRoute: AppRoute = .onboarding
    
    // Navigation stack
    @Published var path = NavigationPath()
}

// MARK: - Navigation

extension AppRouter {
    
    func navigate(to route: AppRoute) {
        path.append(route)
    }
    
    func replace(with route: AppRoute) {
        currentRoute = route
        reset()
    }
    
    func reset() {
        path = NavigationPath()
    }
    
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    func popToRoot() {
        reset()
    }
}
