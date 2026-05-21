//
// HomeView.swift
//

import SwiftUI

struct HomeView: View {

    @StateObject private var homeVM = HomeViewModel()

    @State private var isSidebarCollapsed = false

    var body: some View {

        BackgroundView {
            HStack(spacing: 0) {
                VStack{
                    SidebarView(
                        homeVM: homeVM,
                        compact: isSidebarCollapsed,
                        onToggle: {

                            withAnimation(.spring(duration: 0.3)) {
                                isSidebarCollapsed.toggle()
                            }
                        }
                    )
                    .frame(
                        width: isSidebarCollapsed ? 70 : 260
                    )

                    AccountMenuView(
                        isExpanded: $homeVM.isAccountMenuExpanded,
                        onSignOut: homeVM.signOut,
                        onDeleteAccount: homeVM.deleteAccount
                    )
                    .padding(16)
                }

                detailView
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity
                    )
            }
        }
        .toolbar(.hidden, for: .windowToolbar)
    }
}

extension HomeView {

    @ViewBuilder
    private var detailView: some View {

        switch homeVM.selectedSection {

        case .createProject:
            CreateProjectView(homeVM: homeVM)

        case .projects:
            Text("Projects View")

        case .analysis:
            Text("Analysis View")
        }
    }
}
