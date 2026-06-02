

import SwiftUI
import Combine

struct SceneFile: Identifiable {
    let id = UUID()
    var title: String
    var genres: [String]
    var status: FileStatus
    var date: String
}

enum FileStatus: String {
    case completed  = "Completed"
    case inProgress = "In Progress"
    case pending    = "Pending"

    var color: Color {
        switch self {
        case .completed:  return .primaryRed
        case .inProgress: return Color(red: 1, green: 0.42, blue: 0.21)
        case .pending:    return Color(white: 0.25)
        }
    }
}

struct SceneFolder: Identifiable {
    let id = UUID()
    var name: String
}

@MainActor
final class ProjectsViewModel: ObservableObject {
    @Published var files: [SceneFile] = [
        SceneFile(title: "Title 1", genres: ["Drama", "Series", "Film"], status: .completed, date: "2 days ago"),
        SceneFile(title: "Title 1", genres: ["Drama", "Series", "Film"], status: .completed, date: "2 days ago"),
        SceneFile(title: "Title 1", genres: ["Drama", "Series", "Film"], status: .pending,   date: "2 days ago"),
    ]
    @Published var folders: [SceneFolder] = [
        SceneFolder(name: "Script 1#"),
        SceneFolder(name: "Script 2#"),
        SceneFolder(name: "Script 3#"),
    ]
    @Published var notificationCount: Int = 25

    func addFile() {
        files.insert(SceneFile(title: "New Title", genres: ["Drama"], status: .pending, date: "Just now"), at: 0)
    }

    func deleteFile(_ file: SceneFile) {
        files.removeAll { $0.id == file.id }
    }
}
