//
//  AppRoute.swift
//  Scene
//
//  Created by Yousra Abdelrahman on 21/11/1447 AH.
//
import SwiftUI

enum AppRoute: Hashable {
    
    // MARK: - Core
    
    case onboarding
    case auth
    case home
    case projects
    
    // MARK: - Future
    
    case analysis
    case budget
    case highlightedScript
    
    // MARK: - Project Details
    
    case projectDetails(id: UUID)
}
