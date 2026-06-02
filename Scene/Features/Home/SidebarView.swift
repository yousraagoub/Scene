//
// SidebarView.swift
//

import SwiftUI

struct SidebarView: View {

    @EnvironmentObject var settings: AppSettings
    @ObservedObject var homeVM: HomeViewModel

    let compact: Bool
    let onToggle: () -> Void

    var body: some View {

        VStack(spacing: 8) {

            HStack {
                if !compact {
                    HStack{
                        Image(systemName: "archivebox.circle.fill")
                        Text("#3")
                            
                    }
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
                    .padding(.leading, 14)
                    Spacer()
                }
                Button(action: onToggle) {

                    Image(systemName: "sidebar.left")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
            }
            .padding(.bottom,20)

            SidebarButton(
                item: SidebarItem(
                    title: "Create New Project",
                    systemImage: "plus.circle.fill"
                ),
                isSelected:
                    homeVM.selectedSection == .createProject,
                compact: compact
            ) {
                homeVM.selectedSection = .createProject
            }

            SidebarButton(
                item: SidebarItem(
                    title: "My Projects",
                    systemImage: "archivebox.circle.fill"
                ),
                isSelected:
                    homeVM.selectedSection == .projects,
                compact: compact
            ) {
                homeVM.selectedSection = .projects
            }

            if homeVM.selectedSection == .projects {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Recent Files")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 14)
                        .padding(.top, 8)

                    ForEach(homeVM.recentFiles, id: \.id) { file in
                        HStack(spacing: 8) {
                            Image(systemName: "doc.fill")
                                .font(.system(size: 11))
                                .foregroundColor(.primaryRed)
                            Text(file.title)
                                .font(.system(size: 12))
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 6)
                    }
                }
            }

            Spacer()

        }
        
        
        .padding()
    }
}
