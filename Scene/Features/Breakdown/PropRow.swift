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
                .font(.title)
                .foregroundStyle(.white)

            Spacer()
        }
        .padding()
        .background(Color.white.opacity(0.04))
        .clipShape(
            RoundedRectangle(cornerRadius: 16)
        )
    }
}

