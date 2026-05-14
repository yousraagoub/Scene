//
//  OnboardingData.swift
//  Scene
//
import Foundation

enum OnboardingData {

    static let all: [OnboardingModel] = [

        .init(
            title: "Welcome to Scene",
            subtitle: "Your creative workspace for filmmaking, production, and storytelling.",
            image: "sceneLogo"
        ),

        .init(
            title: "Organize Your Projects",
            subtitle: "Manage scripts, budgets, storyboards, and production workflows in one place.",
            image: "sceneLogo"
        ),

        .init(
            title: "Collaborate Seamlessly",
            subtitle: "Work with your creative team and keep everything synchronized.",
            image: "sceneLogo"
        ),

        .init(
            title: "Ready to Begin",
            subtitle: "Set up your workspace and start building your next production.",
            image: "sceneLogo"
        )
    ]
}
