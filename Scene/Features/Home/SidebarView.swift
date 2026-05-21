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

            // Top controls
            HStack {

                Button(action: onToggle) {

                    Image(systemName: "sidebar.left")
                        .font(.title3)
                }
                .buttonStyle(.plain)

                if !compact {

                    Spacer()
                }
            }
            .padding(.bottom,20)

            SidebarButton(
                item: SidebarItem(
                    title: "Create Project",
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

            Spacer()

        }
        .padding()
    }
}
