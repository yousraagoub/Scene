//
//  HomeView.swift
//

import SwiftUI

struct HomeView: View {

    @StateObject private var homeVM = HomeViewModel()
    @EnvironmentObject var settings: AppSettings

    @State private var isSidebarCollapsed = false

    var body: some View {

        ZStack {

            BackgroundView {

                HStack(spacing: 0) {

                    VStack(spacing: 0) {

                        SidebarView(
                            homeVM: homeVM,
                            compact: isSidebarCollapsed,
                            onToggle: {
                                withAnimation(.spring(duration: 0.3)) {
                                    isSidebarCollapsed.toggle()
                                }
                            }
                        )
                        .frame(width: isSidebarCollapsed ? 70 : 260, height: 218)
                        .glassEffect(in: RoundedRectangle(cornerRadius: 30))

                        Spacer()
                    }
                    .padding(.leading, 30)
                    .padding(.top, 30)
                    .overlay(alignment: .bottomLeading) {

                        AccountMenuView(
                            isExpanded: $homeVM.isAccountMenuExpanded
                        )
                        .padding(.bottom, 30)
                        .padding(.leading, 30)
                    }
                    
                    detailView
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    VStack {
                        Image("sceneLogo")
                            .padding(.top, 30)
                            .padding(.trailing, 30)

                        Spacer()
                    }
                }
            }

            if homeVM.isAccountMenuExpanded {
                Color.black.opacity(0.35)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring(duration: 0.25)) {
                            homeVM.isAccountMenuExpanded = false
                        }
                    }
                
                AccountMenuModalView(
                    isExpanded: $homeVM.isAccountMenuExpanded,
                    onDeleteAccount: homeVM.deleteAccount
                )
                .environmentObject(settings)
                .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.spring(duration: 0.25), value: homeVM.isAccountMenuExpanded)
        .toolbar(.hidden, for: .windowToolbar)
    }
}

extension HomeView {
    @ViewBuilder
    private var detailView: some View{
        switch homeVM.selectedSection{
        case .createProject: CreateProjectView(homeVM: homeVM)
        case .projects: Text("Projects View")
        case .analysis: Text("Analysis View")
        }
    }
}
