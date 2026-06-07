import SwiftUI

struct ProjectsView: View {

    @ObservedObject var homeVM: HomeViewModel

    var body: some View {

        if homeVM.projects.isEmpty {

            VStack {
                Spacer()
                VStack(spacing: 20) {
                    HStack {
                        Spacer()
                        Image(systemName: "folder.badge.plus")
                            .font(.system(size: 60))
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Text("No Projects Yet")
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                }
                Spacer()
            }

        } else {

            VStack(alignment: .leading, spacing: 16) {

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(homeVM.projects) { project in
                            FileCardView(
                                project: project,
                                onTap: {
                                    homeVM.selectedProject = project
                                    homeVM.selectedSection = .breakdown
                                },
                                // Fix 3: call homeVM.deleteProject so CloudKit is also updated
                                onDelete: {
                                    homeVM.deleteProject(project)
                                }
                            )
                        }
                    }
                }

                Spacer()
            }
        }
    }
}

// MARK: - File Card

struct FileCardView: View {

    let project: ProjectModel
    let onTap: () -> Void
    let onDelete: () -> Void

    @State private var hovered = false
    @State private var showDeleteAlert = false

    var body: some View {
        cardContent
            .onHover { hovered = $0 }
            .onTapGesture { onTap() }
            .alert("Delete Project?", isPresented: $showDeleteAlert) {
                Button("Delete", role: .destructive) { onDelete() }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Are you sure you want to delete this project? This action cannot be undone.")
            }
    }
    
    private var cardContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            headerView
            genreAndTypeView
            Spacer()
            timestampView
        }
        .padding(14)
        .frame(width: 205, height: 115)
        .background(cardBackground)
        .overlay(deleteButton)
        .scaleEffect(hovered ? 1.02 : 1.0)
        .animation(.spring(response: 0.22, dampingFraction: 0.7), value: hovered)
    }
    
    private var headerView: some View {
        HStack(alignment: .top) {
            Text(project.title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
            Spacer()
            scriptTypeIcon
        }
    }
    
    private var scriptTypeIcon: some View {
        Image(systemName: project.scriptType == .film ? "film" : "display")
            .font(.system(size: 13))
            .foregroundColor(.white.opacity(0.7))
            .padding(6)
            .background(Color.white.opacity(0.15))
            .clipShape(Circle())
    }
    
    private var genreAndTypeView: some View {
        HStack(spacing: 4) {
            Text(project.genre)
                .font(.system(size: 10))
                .foregroundColor(.secondary)
            Text("•")
                .font(.system(size: 10))
                .foregroundColor(.secondary)
            Text(project.scriptType.rawValue)
                .font(.system(size: 10))
                .foregroundColor(.secondary)
        }
    }
    
    private var timestampView: some View {
        HStack {
            Image(systemName: "clock")
                .font(.system(size: 9))
                .foregroundColor(.secondary)
            Text(project.createdAt.relativeFormatted)
                .font(.system(size: 10))
                .foregroundColor(.secondary)
            Spacer()
        }
    }
    
    private var cardBackground: some View {
        Color(red: 0.137, green: 0.141, blue: 0.122)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .strokeBorder(lineWidth: 2)
                    .foregroundStyle(.ultraThinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.white.opacity(0.15), lineWidth: 1)
            )
    }
    
    private var deleteButton: some View {
        Button(action: { showDeleteAlert = true }) {
            Image(systemName: "trash")
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(Color.primaryRed)
        }
        .buttonStyle(.plain)
        .opacity(hovered ? 1 : 0)
        .animation(.easeInOut(duration: 0.15), value: hovered)
        .offset(x: -8, y: -8)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
    }
}

// MARK: - Date+relativeFormatted

private extension Date {
    var relativeFormatted: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated  // "2 hr. ago", "3 days ago"
        return formatter.localizedString(for: self, relativeTo: .now)
    }
}
