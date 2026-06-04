import SwiftUI

struct ProjectsView: View {

    @StateObject private var vm = ProjectsViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            HStack(spacing: 8) {
                Spacer()
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(vm.files) { file in
                        FileCardView(file: file) {
                            vm.deleteFile(file)
                        }
                    }
                }
                .padding(.bottom, 4)
                .padding(.leading, 10)
            }

            Spacer()
        }
        .padding(.top, 20)
        .padding(.horizontal, 20)
    }
}

// MARK: - File Card

struct FileCardView: View {

    let file: SceneFile
    let onDelete: () -> Void

    @State private var hovered = false
    @State private var showMenu = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            HStack(alignment: .top) {
                Text(file.title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)

                Spacer()

                Image(systemName: file.type == "film" ? "film" : "display")
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.7))
                    .padding(6)
                    .background(Color.white.opacity(0.15))
                    .clipShape(Circle())
            }

            HStack(spacing: 4) {
                ForEach(Array(file.genres.enumerated()), id: \.offset) { i, genre in
                    Text(genre)
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)

                    if i < file.genres.count - 1 {
                        Circle()
                            .fill(Color.secondary)
                            .frame(width: 3, height: 3)
                    }
                }
            }

            Spacer()

            HStack {
                Image(systemName: "clock")
                    .font(.system(size: 9))
                    .foregroundColor(.secondary)

                Text(file.date)
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)

                Spacer()
            }
        }
        .padding(14)
        .frame(width: 205, height: 115)
        .background(Color(red: 0.137, green: 0.141, blue: 0.122))
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
            Button(action: onDelete) {
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
    }
}
