import SwiftUI

struct ProjectsView: View {
    @EnvironmentObject var settings: AppSettings
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
                        Text(settings.language == .arabic ? "لا يوجد مشاريع حتى الآن" : "No Projects Yet")
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
    
    @EnvironmentObject var settings: AppSettings

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
            Text(
                project.genre.localizedGenre(
                    for: settings.language
                )
            )
                .font(.system(size: 10))
                .foregroundColor(.secondary)
            Text("•")
                .font(.system(size: 10))
                .foregroundColor(.secondary)
            Text(
                project.scriptType.localized(
                    for: settings.language
                )
            )
            .font(.system(size: 10))
            .foregroundColor(.secondary)
        }
    }
    
    private var timestampView: some View {
        HStack {
            Image(systemName: "clock")
                .font(.system(size: 9))
                .foregroundColor(.secondary)
            Text(
                project.createdAt.relativeFormatted(
                    for: settings.language
                )
            )
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

    func relativeFormatted(for language: AppLanguage) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated

        formatter.locale = Locale(
            identifier: language == .arabic
            ? "ar"
            : "en"
        )

        return formatter.localizedString(
            for: self,
            relativeTo: .now
        )
    }
}


extension ScriptType {
    
    var arabicName: String {
            switch self {
            case .film:
                return "فيلم"

            case .series:
                return "مسلسل"
            }
        }

    func localized(for language: AppLanguage) -> String {

        switch self {

        case .film:
            return language == .arabic
                ? "فيلم"
                : "Film"

        case .series:
            return language == .arabic
                ? "مسلسل"
                : "Series"
        }
    }
}

extension String {

    func localizedGenre(for language: AppLanguage) -> String {

        switch self {

        case "Drama", "دراما":
            return language == .arabic ? "دراما" : "Drama"

        case "Action", "أكشن":
            return language == .arabic ? "أكشن" : "Action"

        case "Comedy", "كوميديا":
            return language == .arabic ? "كوميديا" : "Comedy"

        case "Horror", "رعب":
            return language == .arabic ? "رعب" : "Horror"

        case "Thriller", "إثارة":
            return language == .arabic ? "إثارة" : "Thriller"

        case "Suspense", "تشويق":
            return language == .arabic ? "تشويق" : "Suspense"

        case "Mystery", "غموض":
            return language == .arabic ? "غموض" : "Mystery"

        case "Crime", "جريمة":
            return language == .arabic ? "جريمة" : "Crime"

        case "Sci-Fi", "خيال علمي":
            return language == .arabic ? "خيال علمي" : "Sci-Fi"

        case "Fantasy", "فانتازيا":
            return language == .arabic ? "فانتازيا" : "Fantasy"

        case "Historical", "تاريخي":
            return language == .arabic ? "تاريخي" : "Historical"

        case "Biography", "سيرة ذاتية":
            return language == .arabic ? "سيرة ذاتية" : "Biography"

        case "Romance", "رومانسي":
            return language == .arabic ? "رومانسي" : "Romance"

        case "Adventure", "مغامرة":
            return language == .arabic ? "مغامرة" : "Adventure"

        case "War", "حربي":
            return language == .arabic ? "حربي" : "War"

        case "Psychological", "نفسي":
            return language == .arabic ? "نفسي" : "Psychological"

        case "Documentary", "وثائقي":
            return language == .arabic ? "وثائقي" : "Documentary"

        case "Family", "عائلي":
            return language == .arabic ? "عائلي" : "Family"

        case "Musical", "موسيقي":
            return language == .arabic ? "موسيقي" : "Musical"

        case "Animation", "رسوم متحركة":
            return language == .arabic ? "رسوم متحركة" : "Animation"

        default:
            return self
        }
    }
}
