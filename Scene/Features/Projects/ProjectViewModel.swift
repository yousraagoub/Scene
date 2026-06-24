//
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
