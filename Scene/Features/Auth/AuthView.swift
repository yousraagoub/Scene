//
//  AuthView.swift
//  Scene
//
//  Created by Yousra Abdelrahman on 19/11/1447 AH.
//

import SwiftUI

struct AuthView: View {
    
    @EnvironmentObject private var appState: AppState
    
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        
        HStack(spacing: 0) {
            
            // LEFT SIDE
            
            VStack(alignment: .leading, spacing: 24) {
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 12) {
                    
                    Text("Welcome Back")
                        .font(.system(size: 42, weight: .bold))
                    
                    Text("Sign in to continue using Scene.")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }
                
                VStack(spacing: 16) {
                    
                    TextField("Email", text: $email)
                        .textFieldStyle(.roundedBorder)
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(.roundedBorder)
                }
                
                Button {
                    
                    // Fake authentication
                    
                    appState.isAuthenticated = true
                    appState.start()
                    
                } label: {
                    
                    Text("Sign In")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.plain)
                .controlSize(.large)
                
                Spacer()
            }
            .padding(60)
            .frame(maxWidth: 500)
            
            Divider()
            
            // RIGHT SIDE
            
            ZStack {
                
                LinearGradient(
                    colors: [
                        .red.opacity(0.8),
                        .brown.opacity(0.8)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                VStack(spacing: 20) {
                    
                    Image("sceneLogo")
                        .font(.system(size: 80))
                        .foregroundStyle(.white)
                    
                    Text("Scene")
                        .font(.system(size: 52, weight: .bold))
                        .foregroundStyle(.white)
                    
                    Text("Creative project management for filmmakers.")
                        .font(.title2)
                        .foregroundStyle(.white.opacity(0.9))
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    AuthView()
        .environmentObject(AppState())
}
