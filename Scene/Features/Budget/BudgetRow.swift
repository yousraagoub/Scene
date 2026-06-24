//
//  BudgetRow.swift
//  Scene
//
import SwiftUI

struct BudgetRow: View {

    let title: String

    @Binding var value: String

    var body: some View {

        HStack {

            Text(title)
            

            Spacer()

            TextField(
                "0",
                text: $value
            )
            .frame(width: 120)
            .textFieldStyle(.roundedBorder)
        }
        .padding()
        .background(
            Color.white.opacity(0.04)
        )
        .clipShape(
            RoundedRectangle(cornerRadius: 16)
        )
    }
}

