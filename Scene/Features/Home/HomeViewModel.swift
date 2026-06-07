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
    @Published var selectedSceneIndex = 0
    @Published var showingBudget = false

    private let cloudService = CloudStorageService()

    // MARK: - Load

    func loadProjects() async {
        do {
            projects = try await cloudService.loadProjects()
            // If no projects yet, show create screen
            if projects.isEmpty {
                selectedSection = .createProject
            }
        } catch {
            print("Failed to load projects: \(error)")
        }
    }

    // MARK: - Delete

    func deleteProject(_ project: ProjectModel) {
        // Remove from UI immediately so the response feels instant
        projects.removeAll { $0.id == project.id }
        if selectedProject?.id == project.id {
            selectedProject = nil
            selectedSection = .projects
        }
        // Delete from CloudKit in the background
        Task {
            do {
                try await cloudService.deleteProject(id: project.id)
            } catch {
                print("Failed to delete project from CloudKit: \(error)")
            }
        }
    }
}
