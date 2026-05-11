//
//  AccountMenuView.swift
//  Scene
//
//  Created by Yousra Abdelrahman on 24/11/1447 AH.
//

import SwiftUI

// MARK: - Account Menu

struct AccountMenuView: View {
    @EnvironmentObject var settings: AppSettings
    
    @Binding var isExpanded: Bool
    
    let onSignOut: () -> Void
    let onDeleteAccount: () -> Void
    
    var body: some View {
        
        Button {
            // IMPORTANT:
            // Do NOT toggle — prevents popover reopen glitch
            if !isExpanded {
                isExpanded = true
            }
        } label: {
            
            Circle()
                .frame(width: 40, height: 40)
                .glassEffect(.clear)
                .overlay {
                    Image(systemName: "person.fill")
                        .font(.headline.bold())
                        .foregroundStyle(.white)
                }
        }
        .buttonStyle(.plain)
        
        // MARK: - Popover
        
        .popover(
            isPresented: $isExpanded,
            attachmentAnchor: .point(.top),
            arrowEdge: .bottom
        ) {
            
            VStack(spacing: 10) {
                Button("English") {
                    settings.language = .english
                }
                
                Button("Arabic") {
                    settings.language = .arabic
                }
                // User info / placeholder
                VStack(spacing: 8) {
                    
                    Circle()
                        .fill(Color.blue.gradient)
                        .frame(width: 52, height: 52)
                        .overlay {
                            Image(systemName: "person.fill")
                                .foregroundStyle(.white)
                                .font(.title3.bold())
                        }
                    
                    Text("John Appleseed")
                        .font(.headline)
                    
                    Text("admin@scene.app")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.bottom, 8)
                
                Divider()
                
                // Actions
                VStack(spacing: 8) {
                    
                    
                    MenuActionButton(
                        title: "Profile",
                        systemImage: "person.crop.circle",
                        role: .normal,
                        action: {}
                    )
                    
                    MenuActionButton(
                        title: "Sign Out",
                        systemImage: "rectangle.portrait.and.arrow.right",
                        role: .normal,
                        action: {
                            isExpanded = false
                            onSignOut()
                        }
                    )
                    
                    MenuActionButton(
                        title: "Delete Account",
                        systemImage: "trash.fill",
                        role: .destructive,
                        action: {
                            isExpanded = false
                            onDeleteAccount()
                        }
                    )
                }
            }
            .padding(16)
            .frame(width: 260)
            
            // Safety sync (prevents state desync issues)
            .onDisappear {
                isExpanded = false
            }
        }
    }
}
