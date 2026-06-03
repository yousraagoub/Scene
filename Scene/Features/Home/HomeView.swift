//
//  HomeView.swift
//

import SwiftUI

struct HomeView: View {

    @StateObject private var homeVM = HomeViewModel()
    @StateObject private var authService = CloudAuthService()
    @EnvironmentObject var settings: AppSettings

    @State private var isSidebarCollapsed = true

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
                        .frame(width: isSidebarCollapsed ? 60 : 260, height: 218)
                        .glassEffect(in: RoundedRectangle(cornerRadius: 30))

                        Spacer()
                    }
                    .padding(.leading, 30)
                    .padding(.top, 30)
                    .overlay(alignment: .bottomLeading) {

                        SettingsView(
                            isExpanded: $homeVM.isSettingsExpanded
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
                        //test
                        Text(authService.authState == .signedIn ? "✅ Signed in" : "❌ Not signed in")
                            .foregroundStyle(.white)
                    }
                }
            }

            if homeVM.isSettingsExpanded {
                Color.black.opacity(0.35)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring(duration: 0.25)) {
                            homeVM.isSettingsExpanded = false
                        }
                    }
                
                SettingsViewModel(
                    isExpanded: $homeVM.isSettingsExpanded
                )
                .environmentObject(settings)
                .transition(.scale.combined(with: .opacity))
            }
            
            if homeVM.isCreateProjectExpanded {

                Color.black.opacity(0.35)
                    .ignoresSafeArea()
                    .onTapGesture {

                        withAnimation(.spring(duration: 0.25)) {
                            homeVM.isCreateProjectExpanded = false
                        }
                    }

                CreateProjectPopUpView(
                    homeVM: homeVM,
                    isExpanded: $homeVM.isCreateProjectExpanded
                )
                .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.spring(duration: 0.25), value: homeVM.isSettingsExpanded)
        
    }
}

extension HomeView {
    @ViewBuilder
    private var detailView: some View{
        switch homeVM.selectedSection{
        case .createProject:
            CreateProjectButtonView(homeVM: homeVM)
        case .projects:
            ProjectsView()
        case .analysis:
            Text("Analysis View")
        }
    }
}
