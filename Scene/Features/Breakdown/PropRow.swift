//
//  PropRow.swift
//  Scene
//
import SwiftUI

struct PropRow: View {

    let prop: PropBreakdown

    var body: some View {

        HStack {

            Text(prop.name)
                .font(.title2)
                .foregroundStyle(.white)

            Spacer()
        }
        .padding()
        .glassEffect(
            in: RoundedRectangle(cornerRadius: 16)
        )
        .shadow(color: Color.propsCard.opacity(0.3), radius: 4)
    }
}

