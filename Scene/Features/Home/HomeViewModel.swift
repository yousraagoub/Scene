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
}

