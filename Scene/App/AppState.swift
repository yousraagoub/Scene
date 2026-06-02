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
    
    func start(authService: CloudAuthService) async {
        await authService.checkAuth()
 
        switch authService.authState {
        case .signedIn:
            replace(with: .home)
        case .signedOut, .restricted, .unknown:
            replace(with: .onboarding)
        }
    }
//    func start() {
//
//        if isFirstLaunch {
//            replace(with: .onboarding)
//            return
//        }
//
//        replace(with: .home)
//    }
}
