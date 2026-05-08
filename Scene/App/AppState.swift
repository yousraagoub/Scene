//
//  AppState.swift
//  Scene
//
//  Created by Yousra Abdelrahman on 19/11/1447 AH.
//
import SwiftUI
import Combine

final class AppState: ObservableObject {
    
    @Published var router = AppRouter()
    
    // MARK: - Session
    
    @Published var isFirstLaunch: Bool = true
    @Published var isAuthenticated: Bool = false
    
    // MARK: - Current User
    
    @Published var currentUserID: UUID?
}

// MARK: - Launch Flow

extension AppState {
    
    func start() {
        
        if isFirstLaunch {
            router.replace(with: .onboarding)
            return
        }
        
        if !isAuthenticated {
            router.replace(with: .auth)
            return
        }
        
        router.replace(with: .home)
    }
}
