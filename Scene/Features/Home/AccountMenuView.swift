//
//  AccountMenuView.swift
//  Scene
//
import SwiftUI

struct AccountMenuView: View {
    @EnvironmentObject var settings: AppSettings
    @Binding var isExpanded: Bool
    
    let onSignOut: () -> Void
    let onDeleteAccount: () -> Void
    
    var body: some View {
        
        Button {
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
        
        .popover(
            isPresented: $isExpanded,
            attachmentAnchor: .point(.top),
            arrowEdge: .bottom
        ) {
            
            VStack(spacing: 10) {
                
                HStack(spacing: 8) {
                    Circle()
                        .fill(Color.primaryRed.gradient)
                        .frame(width: 52, height: 52)
                        .overlay {
                            Image(systemName: "person.fill")
                                .foregroundStyle(.white)
                                .font(.title3.bold())
                        }
                    
                    Text("John Appleseed")
                        .font(.headline)
                }
                .padding(.bottom, 8)
                Divider()
                VStack(spacing: 8) {
                    MenuActionButton(
                        title: "Settings",
                        systemImage: "gearshape.fill",
                        role: .normal,
                        action: {}
                    )
                }
                Picker("Language", selection: $settings.language) {
                    Text("English").tag(AppLanguage.english)
                    Text("Arabic").tag(AppLanguage.arabic)
                }
                .pickerStyle(.segmented)
                .padding()
                .tint(.primaryRed)
            }
            .padding(16)
            .frame(width: 260)
            .onDisappear {
                isExpanded = false
            }
        }
    }
}
