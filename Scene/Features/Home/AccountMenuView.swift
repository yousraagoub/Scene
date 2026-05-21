//
//  AccountMenuView.swift
//  Scene
//

import SwiftUI

struct AccountMenuView: View {
    
    @Binding var isExpanded: Bool
    
    var body: some View {
        
        Button {
            withAnimation(.spring(duration: 0.25)) {
                isExpanded = true
            }
        } label: {
            
            Image(systemName: "person.fill")
                .font(.system(size: 16))
                      //                .font(.headline.bold())
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
        }
        .buttonStyle(.plain)
        .frame(width: 70, height: 70)
        .glassEffect(in: Circle())
    }
    
}
