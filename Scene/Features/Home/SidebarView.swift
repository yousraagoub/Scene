//
//  Untitled.swift
//  Scene
//
//  Created by Yousra Abdelrahman on 24/11/1447 AH.
//

import SwiftUI
// MARK: - Sidebar

struct SidebarView: View {
    @EnvironmentObject var settings: AppSettings
    @ObservedObject var homeVM: HomeViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            //Testing
            Text(settings.language.code)
                .foregroundStyle(.blue)
            // App Branding
            HStack(spacing: 12) {
                Image("sceneLogo")
                    .font(.title2)
                Text(settings.language.code == "ar" ? "سِين" : "Scene")
                    .font(.title3.weight(.semibold))
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.top, 24)
            .padding(.bottom, 30)
            
            // Navigation Menu
            VStack(spacing: 8) {
                ForEach(homeVM.sidebarItems) { item in
                    
                    SidebarButton(
                        item: item,
                        isSelected: homeVM.selectedSidebarItem == item
                    ) {
                        homeVM.selectedSidebarItem = item
                    }
                }
            }
            .padding(.horizontal, 12)
            
            Spacer()
        }
        // Account Section
        AccountMenuView(
            isExpanded: $homeVM.isAccountMenuExpanded,
            onSignOut: homeVM.signOut,
            onDeleteAccount: homeVM.deleteAccount
        )
        .padding(16)
       
    }
}
