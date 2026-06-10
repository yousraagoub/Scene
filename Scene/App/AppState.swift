//
//  AppState.swift
//  Scene
//
import SwiftUI
import Combine

final class AppState: ObservableObject {

    @Published var currentRoute: AppRoute = .onboarding

    var isFirstLaunch: Bool {
        !UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
    }

    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
    }
    
    // MARK: - Debug/Testing Helper
    func resetOnboarding() {
        UserDefaults.standard.removeObject(forKey: "hasLaunchedBefore")
        replace(with: .onboarding)
    }
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
    
    func start(authService: CloudAuthService) async {
        let hasLaunchedBefore = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        print("🚀 App Start - hasLaunchedBefore: \(hasLaunchedBefore)")
        
        if !hasLaunchedBefore {
            print("🚀 Showing onboarding (first launch)")
            replace(with: .onboarding)
            return
        }
        
        print("🚀 Checking auth status...")
        await authService.checkAuth()
 
        switch authService.authState {
        case .signedIn:
            print("🚀 User signed in - going to home")
            replace(with: .home)
        case .signedOut, .restricted, .unknown:
            print("🚀 User not authenticated - showing onboarding")
            replace(with: .onboarding)
        }
    }
    func start() {

        if isFirstLaunch {
            replace(with: .onboarding)
            return
        }

        replace(with: .home)
    }
}
