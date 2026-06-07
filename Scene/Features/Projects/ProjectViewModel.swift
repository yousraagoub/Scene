//import SwiftUI
//import Combine
//
//struct SceneFile: Identifiable {
//    let id = UUID()
//    var title: String
//    var genres: [String]
//    var date: String
//    var type: String // "film" أو "series"
//}
//
//struct SceneFolder: Identifiable {
//    let id = UUID()
//    var name: String
//}
//
//@MainActor
//final class ProjectsViewModel: ObservableObject {
//    @Published var files: [SceneFile] = [
//        SceneFile(title: "Title 1", genres: ["Drama", "Series"], date: "2 days ago", type: "series"),
//        SceneFile(title: "Title 1", genres: ["Drama", "Film"], date: "2 days ago", type: "film"),
//        SceneFile(title: "Title 1", genres: ["Drama", "Series"], date: "2 days ago", type: "series"),
//    ]
//    @Published var folders: [SceneFolder] = [
//        SceneFolder(name: "Script 1#"),
//        SceneFolder(name: "Script 2#"),
//        SceneFolder(name: "Script 3#"),
//    ]
//    @Published var notificationCount: Int = 25
//
//    func addFile() {
//        files.insert(SceneFile(title: "New Title", genres: ["Drama"], date: "Just now", type: "series"), at: 0)
//    }
//
//    func deleteFile(_ file: SceneFile) {
//        files.removeAll { $0.id == file.id }
//    }
//}

import Observation

@Observable
final class ProjectViewModel {

    let project: ProjectModel
    var breakdown: ScriptBreakdown?
    var isLoading = false
    var error: Error?

    private let cloudService = CloudStorageService()

    init(project: ProjectModel) {
        self.project = project
    }

    func loadBreakdown() async {
        guard project.status == .ready else { return }
        isLoading = true
        defer { isLoading = false }
        do {
            breakdown = try await cloudService.loadBreakdown(for: project.id)
        } catch {
            self.error = error
        }
    }

    // Fire-and-forget — updates CloudKit in background, surfaces errors via self.error
    func updateCost(_ cost: Double, entityId: String) {
        Task {
            do {
                try await cloudService.updateCost(cost, entityId: entityId, projectId: project.id)
            } catch {
                self.error = error
            }
        }
    }
}
