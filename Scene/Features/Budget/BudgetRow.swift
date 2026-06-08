//
//  BudgetRow.swift
//  Scene
//
import SwiftUI

struct BudgetRow: View {

    let title: String
    
    let icon: String
    
    let color: Color

    @Binding var value: String

    var body: some View {

        HStack {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 22)
                .foregroundStyle(color)
            
            Text(title)
                .font(.title2)
                .foregroundStyle(.white)

            Spacer()

            TextField(
                "0",
                text: $value
            )
            .frame(height: 20, alignment: .topLeading)
            .fixedSize(horizontal: true, vertical: false)
            .textFieldStyle(.roundedBorder)
        }
        .padding()
        .clipShape(
            RoundedRectangle(cornerRadius: 16)
        )
        .glassEffect(
            in: RoundedRectangle(cornerRadius: 16)
        )
        
    }
}

