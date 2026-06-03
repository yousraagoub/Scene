//
//  HomeViewModel.swift
//  Scene
//
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var selectedSection: HomeSection = .createProject
    @Published var isSettingsExpanded = false
    @Published var isCreateProjectExpanded = false
    @Published var projects: [ProjectModel] = []
    @Published var selectedProject: ProjectModel?
    
    func printProjects() {

        print("------ STORED PROJECTS ------")

        for project in projects {

            print("Title: \(project.title)")
            print("Genre: \(project.genre)")
            print("Type: \(project.scriptType.rawValue)")
        }

        print("-----------------------------")
    }
}

