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
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28, height: 28)
                        Text("\(homeVM.projects.count)")
                            
                    }
                    .font(.title2)
                    .foregroundColor(.primaryRed)
                    .padding(.leading, 14)
                    Spacer()
                }
                Button(action: onToggle) {

                    Image(systemName: "sidebar.left")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28, height: 28)
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
            }
            .padding([.bottom, .top],20)

            SidebarButton(
                item: SidebarItem(
                    title: settings.language == .arabic ? "أنشئ مشروع جديد" : "Create New Project",
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
                    title: settings.language == .arabic ? "مشاريعي" : "My Projects",
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
