//
//  CreateProjectView.swift
//  Scene
//
import SwiftUI

struct CreateProjectView: View {
    
    var body: some View {
        
        VStack(spacing: 20) {
            
            Text("Create New Project")
                .font(.largeTitle.bold())
            
            Text("Project setup will go here")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
