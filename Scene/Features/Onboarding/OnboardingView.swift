//
//  OnboardingView.swift
//  Scene
//
//  Created by Yousra Abdelrahman on 19/11/1447 AH.
//

import SwiftUI

struct OnboardingView: View {
    
    @EnvironmentObject private var appState: AppState
    
    @State private var currentPage = 0
    
    private let pages: [OnboardingPage] = [
        
        .init(
            title: "Welcome to Scene",
            subtitle: "Your creative workspace for filmmaking, production, and storytelling.",
            image: "sceneLogo"
        ),
        
        .init(
            title: "Organize Your Projects",
            subtitle: "Manage scripts, budgets, storyboards, and production workflows in one place.",
            image: "sceneLogo"
        ),
        
        .init(
            title: "Collaborate Seamlessly",
            subtitle: "Work with your creative team and keep everything synchronized.",
            image: "sceneLogo"
        ),
        
        .init(
            title: "Ready to Begin",
            subtitle: "Set up your workspace and start building your next production.",
            image: "sceneLogo"
        )
    ]
    
    var body: some View {
        
        ZStack {
            
            // Background
            
            LinearGradient(
                colors: [
                    Color.red.opacity(0.08),
                    Color.red.opacity(0.05),
                    Color.black.opacity(0.02)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                
                Spacer()
                
                // MARK: - Icon
                
                Image(pages[currentPage].image)
                    .font(.system(size: 90, weight: .light))
                    .foregroundStyle(.red)
                    .symbolRenderingMode(.hierarchical)
                    .animation(.easeInOut(duration: 0.25), value: currentPage)
                
                // MARK: - Text
                
                VStack(spacing: 16) {
                    
                    Text(pages[currentPage].title)
                        .font(.system(size: 42, weight: .bold))
                    
                    Text(pages[currentPage].subtitle)
                        .font(.title3)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .frame(maxWidth: 620)
                }
                .animation(.easeInOut(duration: 0.25), value: currentPage)
                
                Spacer()
                
                // MARK: - Indicators
                
                HStack(spacing: 10) {
                    
                    ForEach(0..<pages.count, id: \.self) { index in
                        
                        Capsule()
                            .fill(
                                index == currentPage
                                ? Color.red
                                : Color.gray.opacity(0.25)
                            )
                            .frame(
                                width: index == currentPage ? 28 : 10,
                                height: 10
                            )
                            .animation(.spring(duration: 0.25), value: currentPage)
                    }
                }
                
                // MARK: - Buttons
                
                HStack {
                    
                    if currentPage > 0 {
                        
                        Button("Back") {
                            
                            withAnimation(.easeInOut(duration: 0.2)) {
                                currentPage -= 1
                            }
                        }
                        .buttonStyle(.plain)
                    }
                    
                    Spacer()
                    
                    Button {
                        
                        if currentPage < pages.count - 1 {
                            
                            withAnimation(.easeInOut(duration: 0.25)) {
                                currentPage += 1
                            }
                            
                        } else {
                            
                            // MARK: - Finish Onboarding
                            
                            appState.isFirstLaunch = false
                            appState.start()
                        }
                        
                    } label: {
                        
                        Text(currentPage == pages.count - 1 ? "Get Started" : "Next")
                            .fontWeight(.semibold)
                            
                            .frame(width: 140, height: 40)
//                            .glassEffect(.clear.tint(.red))
                    }
                    .buttonStyle(.plain)
                    .controlSize(.large)
                }
                .padding(.top, 10)
            }
            .padding(60)
            .frame(maxWidth: 820)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

// MARK: - Model

struct OnboardingPage {
    
    let title: String
    let subtitle: String
    let image: String
}

// MARK: - Preview

#Preview {
    
    OnboardingView()
        .environmentObject(AppState())
}
