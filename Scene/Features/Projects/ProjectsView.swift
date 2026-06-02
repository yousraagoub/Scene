//
//  ProjectsView.swift
//  Scene
//

import SwiftUI

struct ProjectsView: View {

    @StateObject private var vm = ProjectsViewModel()

    var body: some View {
        VStack(alignment: .trailing, spacing: 16) {

            HStack(spacing: 8) {
                Text("All Previous Files")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                Image(systemName: "ellipsis.circle.fill")
                    .foregroundColor(.secondary)
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
    @State private var hovered  = false
    @State private var showMenu = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            HStack {
                Image(systemName: "chevron.right")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                Spacer()
                Text(file.title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                Button { showMenu.toggle() } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
                .popover(isPresented: $showMenu) {
                    Button(role: .destructive, action: onDelete) {
                        Label("Delete", systemImage: "trash")
                    }
                    .padding(12)
                }
            }
            .padding(.bottom, 8)

            HStack(spacing: 4) {
                ForEach(Array(file.genres.enumerated()), id: \.offset) { i, genre in
                    Text(genre).font(.system(size: 10)).foregroundColor(.secondary)
                    if i < file.genres.count - 1 {
                        Circle().fill(Color.secondary).frame(width: 3, height: 3)
                    }
                }
            }

            Spacer()

            HStack {
                Text(file.status.rawValue)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(file.status.color)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                Spacer()
                Image(systemName: "clock").font(.system(size: 9)).foregroundColor(.secondary)
                Text(file.date).font(.system(size: 10)).foregroundColor(.secondary)
            }
        }
        .padding(14)
        .frame(width: 205, height: 115)
        .background(Color(red: 0.137, green: 0.141, blue: 0.122))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(hovered ? Color.primaryRed.opacity(0.4) : Color.white.opacity(0.08), lineWidth: 1)
        )
        .scaleEffect(hovered ? 1.02 : 1.0)
        .animation(.spring(response: 0.22, dampingFraction: 0.7), value: hovered)
        .onHover { hovered = $0 }
    }
}
