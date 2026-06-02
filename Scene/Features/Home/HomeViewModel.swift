//
//  HomeViewModel.swift
//  Scene
//
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var selectedSection: HomeSection = .createProject
    @Published var isSettingsExpanded = false
//raghad
    @Published var recentFiles: [SceneFile] = [
        SceneFile(title: "Title 1", genres: ["Drama"], status: .completed, date: "2 days ago"),
        SceneFile(title: "Title 1", genres: ["Drama"], status: .completed, date: "2 days ago"),
        SceneFile(title: "Title 1", genres: ["Drama"], status: .pending,   date: "2 days ago"),
    ]
}

