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
        VStack {
            HStack {
                if !compact {
                    HStack{
                        Image(systemName: "archivebox.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 22, height: 22)
                        Text("\(homeVM.projects.count)")
                            .font(.title2)
                    }
                    .foregroundColor(.primaryRed)
                    Spacer()
                }
                Button(action: onToggle) {
                    Image(systemName: "sidebar.left")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22, height: 22)
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
            }
            .frame(width: 202, height: 22)
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
        }
        .padding()
    }
}
