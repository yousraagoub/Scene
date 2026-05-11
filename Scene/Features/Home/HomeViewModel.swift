//
//  HomeViewModel.swift
//  Scene
//
//  Created by Yousra Abdelrahman on 19/11/1447 AH.
//
import Combine
// MARK: - View Model

@MainActor
final class HomeViewModel: ObservableObject {
    
    @Published var selectedSidebarItem: SidebarItem?
    @Published var isAccountMenuExpanded = false
    
    let sidebarItems: [SidebarItem] = [
        SidebarItem(title: "Create Project", systemImage: "plus.square.fill"),
        SidebarItem(title: "My Projects", systemImage: "folder.fill")
    ]
    
    let dashboardCards: [DashboardCard] = [
        DashboardCard(
            title: "Total Projects",
            value: "12",
            icon: "shippingbox.fill"
        ),
        DashboardCard(
            title: "Placeholder",
            value: nil,
            icon: "square.dashed"
        ),
        DashboardCard(
            title: "Placeholder",
            value: nil,
            icon: "square.dashed"
        ),
        DashboardCard(
            title: "Placeholder",
            value: nil,
            icon: "square.dashed"
        )
    ]
    
    init() {
        selectedSidebarItem = sidebarItems.first
    }
    
    func signOut() {
        print("Sign Out tapped")
    }
    
    func deleteAccount() {
        print("Delete Account tapped")
    }
}
