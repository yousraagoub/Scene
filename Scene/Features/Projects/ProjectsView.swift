import SwiftUI

struct ProjectsView: View {

    @ObservedObject var homeVM: HomeViewModel

    var body: some View {

        if homeVM.projects.isEmpty {

            VStack {

                Spacer()

                VStack(spacing: 20) {

                    HStack{
                        Spacer()
                        Image(systemName: "folder.badge.plus")
                            .font(.system(size: 60))
                            .foregroundStyle(.secondary)
                        Spacer()
                    }

                    HStack{
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
                                onDelete: {

                                    homeVM.projects.removeAll {
                                        $0.id == project.id
                                    }

                                    if homeVM.selectedProject?.id == project.id {
                                        homeVM.selectedProject = nil
                                    }
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
    @State private var showDeleteAlert = false   // ✅ جديد

    var body: some View {

        VStack(alignment: .leading, spacing: 0) {

            HStack(alignment: .top) {

                Text(project.title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)

                Spacer()

                Image(
                    systemName: project.scriptType == .film ? "film" : "display"
                )
                .font(.system(size: 13))
                .foregroundColor(.white.opacity(0.7))
                .padding(6)
                .background(Color.white.opacity(0.15))
                .clipShape(Circle())
            }

            HStack(spacing: 4) {
                Text(project.genre)
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }

            Spacer()

            HStack {

                Image(systemName: "clock")
                    .font(.system(size: 9))
                    .foregroundColor(.secondary)

                Text("Just now")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)

                Spacer()
            }
        }
        .padding(14)
        .frame(width: 205, height: 115)
        .background(
            Color(red: 0.137, green: 0.141, blue: 0.122)
        )
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
        .overlay(alignment: .bottomTrailing) {

            Button(action: {
                showDeleteAlert = true   // ✅ بدل الحذف المباشر
            }) {
                Image(systemName: "trash")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(Color.primaryRed)
            }
            .buttonStyle(.plain)
            .opacity(hovered ? 1 : 0)
            .animation(.easeInOut(duration: 0.15), value: hovered)
            .offset(x: -8, y: -8)
        }
        .scaleEffect(hovered ? 1.02 : 1.0)
        .animation(.spring(response: 0.22, dampingFraction: 0.7), value: hovered)
        .onHover { hovered = $0 }
        .onTapGesture { onTap() }

        // 🔔 Alert تأكيد الحذف
        .alert("Delete Project?", isPresented: $showDeleteAlert) {

            Button("Delete", role: .destructive) {
                onDelete()
            }

            Button("Cancel", role: .cancel) { }

        } message: {
            Text("Are you sure you want to delete this project? This action cannot be undone.")
        }
    }
}
