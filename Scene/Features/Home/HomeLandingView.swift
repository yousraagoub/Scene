//
//  HomeLandingView.swift
//  Scene
//
import SwiftUI

struct HomeLandingView: View {
    
    @ObservedObject var homeVM: HomeViewModel
    
    var body: some View {
        
        VStack(spacing: 24) {
            
            Text("Welcome")
                .font(.largeTitle.bold())
            
            Text("Start by creating a new project")
                .foregroundStyle(.secondary)
            
            Button {
                homeVM.selectedSection = .projects
            } label: {
                
                Label("Create New Project", systemImage: "plus.circle.fill")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: 280)
                    .foregroundStyle(.primaryRed)
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
