//
//  HomeView.swift
//  Scene
//
//  Created by Yousra Abdelrahman on 19/11/1447 AH.
//
//

import SwiftUI
import Combine

// MARK: - Models

struct SidebarItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let systemImage: String
}

struct DashboardCard: Identifiable {
    let id = UUID()
    let title: String
    let value: String?
    let icon: String
}

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

// MARK: - Main View

struct HomeView: View {
    
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationSplitView {
            SidebarView(viewModel: viewModel)
        } detail: {
            DashboardView(cards: viewModel.dashboardCards)
        }
        .navigationTitle("Home")
        .frame(minWidth: 1200, minHeight: 750)
    }
}

// MARK: - Sidebar

struct SidebarView: View {
    
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            
            // App Branding
            HStack(spacing: 12) {
                Image(systemName: "macwindow")
                    .font(.title2)
                    .foregroundStyle(.blue)
                
                Text("Scene Project")
                    .font(.title3.weight(.semibold))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.top, 24)
            .padding(.bottom, 30)
            
            // Navigation Menu
            VStack(spacing: 8) {
                ForEach(viewModel.sidebarItems) { item in
                    
                    SidebarButton(
                        item: item,
                        isSelected: viewModel.selectedSidebarItem == item
                    ) {
                        viewModel.selectedSidebarItem = item
                    }
                }
            }
            .padding(.horizontal, 12)
            
            Spacer()
            
            // Account Section
            AccountMenuView(
                isExpanded: $viewModel.isAccountMenuExpanded,
                onSignOut: viewModel.signOut,
                onDeleteAccount: viewModel.deleteAccount
            )
            .padding(16)
        }
        .background(.ultraThinMaterial)
    }
}

// MARK: - Sidebar Button

struct SidebarButton: View {
    
    let item: SidebarItem
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                
                Image(systemName: item.systemImage)
                    .font(.system(size: 16, weight: .semibold))
                
                Text(item.title)
                    .font(.system(size: 15, weight: .medium))
                
                Spacer()
            }
            .foregroundStyle(isSelected ? .white : .primary)
            .padding(.vertical, 12)
            .padding(.horizontal, 14)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(isSelected ? Color.blue : Color.clear)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Dashboard

struct DashboardView: View {
    
    let cards: [DashboardCard]
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                
                Text("Dashboard")
                    .font(.largeTitle.bold())
                
                LazyVGrid(columns: columns, spacing: 24) {
                    ForEach(cards) { card in
                        DashboardCardView(card: card)
                    }
                }
            }
            .padding(32)
        }
        .background(
            Color(nsColor: .windowBackgroundColor)
        )
    }
}

// MARK: - Dashboard Card

struct DashboardCardView: View {
    
    let card: DashboardCard
    
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            
            HStack {
                Image(systemName: card.icon)
                    .font(.title2)
                    .foregroundStyle(.blue)
                
                Spacer()
            }
            
            Spacer()
            
            Text(card.title)
                .font(.headline)
            
            if let value = card.value {
                Text(value)
                    .font(.system(size: 40, weight: .bold))
            } else {
                Text("Coming Soon")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(24)
        .frame(height: 220)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.background)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .strokeBorder(Color.gray.opacity(0.12))
        )
        .shadow(
            color: .black.opacity(0.04),
            radius: 10,
            y: 4
        )
    }
}

// MARK: - Account Menu

struct AccountMenuView: View {
    
    @Binding var isExpanded: Bool
    
    let onSignOut: () -> Void
    let onDeleteAccount: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            
            Button {
                withAnimation(.spring(duration: 0.25)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack(spacing: 12) {
                    
                    Circle()
                        .fill(Color.blue.gradient)
                        .frame(width: 40, height: 40)
                        .overlay {
                            Text("A")
                                .font(.headline.bold())
                                .foregroundStyle(.white)
                        }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Account")
                            .font(.headline)
                        
                        Text("admin@scene.app")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.gray.opacity(0.08))
                )
            }
            .buttonStyle(.plain)
            
            if isExpanded {
                VStack(spacing: 8) {
                    
                    MenuActionButton(
                        title: "John Appleseed",
                        systemImage: "person.fill",
                        role: .normal,
                        action: {}
                    )
                    
                    MenuActionButton(
                        title: "Sign Out",
                        systemImage: "rectangle.portrait.and.arrow.right",
                        role: .normal,
                        action: onSignOut
                    )
                    
                    MenuActionButton(
                        title: "Delete Account",
                        systemImage: "trash.fill",
                        role: .destructive,
                        action: onDeleteAccount
                    )
                }
                .transition(
                    .move(edge: .bottom)
                    .combined(with: .opacity)
                )
            }
        }
    }
}

// MARK: - Menu Action Button

struct MenuActionButton: View {
    
    enum Role {
        case normal
        case destructive
    }
    
    let title: String
    let systemImage: String
    let role: Role
    let action: () -> Void
    
    var foregroundColor: Color {
        switch role {
        case .normal:
            return .primary
        case .destructive:
            return .red
        }
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                
                Image(systemName: systemImage)
                    .frame(width: 18)
                
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                
                Spacer()
            }
            .foregroundStyle(foregroundColor)
            .padding(.vertical, 10)
            .padding(.horizontal, 14)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.gray.opacity(0.06))
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    HomeView()
}
