//
//  SettingsView.swift
//  Scene
//

import SwiftUI

struct SettingsView: View {
    
    @Binding var isExpanded: Bool
    
    var body: some View {
        
        Button {
            withAnimation(.spring(duration: 0.25)) {
                isExpanded = true
            }
        } label: {
            
            Image(systemName: "gearshape.fill")
                .font(.system(size: 16))
                .foregroundColor(.white)
                .padding()
        }
        .buttonStyle(.plain)
        .glassEffect(in: Circle())
    }
    
}
