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

            Spacer()

        }
        
        
        .padding()
    }
}
