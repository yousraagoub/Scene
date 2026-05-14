//
//  SidebarView.swift
//  Scene
//

import SwiftUI

struct SidebarView: View {
    
    @EnvironmentObject var settings: AppSettings
    @ObservedObject var homeVM: HomeViewModel
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            HStack(spacing: 12) {
                
                Image("sceneLogo")
                
                Text(
                    settings.language.code == "ar"
                    ? "سِين"
                    : "Scene"
                )
                .font(.title3.weight(.semibold))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.top, 24)
            .padding(.bottom, 30)
            
            VStack(spacing: 8) {
                
                SidebarButton(
                    item: SidebarItem(
                        title: "Home",
                        systemImage: "house.fill"
                    ),
                    isSelected: homeVM.selectedSection == .home
                ) {
                    homeVM.selectedSection = .home
                }
                
                SidebarButton(
                    item: SidebarItem(
                        title: "Create Project",
                        systemImage: "plus.square.fill"
                    ),
                    isSelected: homeVM.selectedSection == .createProject
                ) {
                    homeVM.selectedSection = .createProject
                }
                
                SidebarButton(
                    item: SidebarItem(
                        title: "My Projects",
                        systemImage: "folder.fill"
                    ),
                    isSelected: homeVM.selectedSection == .projects
                ) {
                    homeVM.selectedSection = .projects
                }
            }
            .padding(.horizontal, 12)
            
            Spacer()
            
            AccountMenuView(
                isExpanded: $homeVM.isAccountMenuExpanded,
                onSignOut: homeVM.signOut,
                onDeleteAccount: homeVM.deleteAccount
            )
            .padding(16)
        }
    }
}
