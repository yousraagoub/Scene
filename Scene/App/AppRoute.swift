//
//  AppRoute.swift
//  Scene
//
import SwiftUI
enum AppRoute: Hashable {
    case onboarding
    case home
    case projects
    case createProject
    case analysis
    case budget
    case highlightedScript
    case projectDetails(id: UUID)
}
