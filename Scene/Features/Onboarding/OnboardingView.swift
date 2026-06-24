//
//  OnboardingView.swift
//  Scene
//
import SwiftUI

struct OnboardingView: View {
    
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var authService: CloudAuthService
    
    @State private var currentPage = 0
    
    private let pages = OnboardingData.all
    
    var body: some View {
            ZStack{
                //For Animation or Images
                VStack {
                    HStack {
                        
                        if currentPage > 0 {
                            
                            Button("Back") {
                                
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    currentPage -= 1
                                }
                            }
                            .buttonStyle(.plain)
                            .fontWeight(.medium)
                            .font(.system(size: 20))
                            
                        }
                        
                        Spacer()
                        
                        Button {
                            
                            if currentPage < pages.count - 1 {
                                
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    currentPage += 1
                                }
                                
                            } else {
                
                                Task {
                                    appState.completeOnboarding()
                                    await authService.checkAuth()
                                    
                                    if authService.isSignedIn {
                                        appState.navigate(to: .home)
                                    } else {
                                        // Handle unauthenticated state
                                        // For now, staying on onboarding or could show auth prompt
                                        appState.navigate(to: .onboarding)
                                    }
                                }
                            }
                            
                        } label: {
                            
                            Text(currentPage == pages.count - 1 ? "Get Started" : "Next")
                                .fontWeight(.medium)
                                .font(.system(size: 20))
                                
                                .frame(width: 140, height: 40)
                        }
                        .buttonStyle(.plain)
                        .controlSize(.large)
                    }
                    .padding(.top, 20)
                   
                    
                    Spacer()
                    
                    Image(pages[currentPage].image)
                        .font(.system(size: 90, weight: .light))
                        .foregroundStyle(.primaryRed)
                        .symbolRenderingMode(.hierarchical)
                        .animation(.easeInOut(duration: 0.25), value: currentPage)
                        .padding(.top, 110)
                    
                    VStack {
                        
                        Text(pages[currentPage].title)
                            .font(.system(size: 42, weight: .bold))
                            .dynamicTypeSize(.accessibility5)
                        
                        Text(pages[currentPage].subtitle)
                            .font(.system(size: 42, weight: .bold))
                            .dynamicTypeSize(.accessibility5)
                    }
                    .animation(.easeInOut(duration: 0.25), value: currentPage)
                    
                    Spacer()
                    
                    HStack(spacing: 10) {
                        
                        ForEach(0..<pages.count, id: \.self) { index in
                            
                            Capsule()
                                .fill(
                                    index == currentPage
                                    ? Color.primaryRed
                                    : Color.gray.opacity(0.25)
                                )
                                .frame(
                                    width: index == currentPage ? 46 : 9,
                                    height: 9
                                )
                                .animation(.spring(duration: 0.25), value: currentPage)
                        }
                    }
                    
                    Spacer()

                }
                .frame(maxWidth: 820)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
    }
}

#Preview {
    
    OnboardingView()
        .environmentObject(AppState())
        .environmentObject(CloudAuthService())
}
