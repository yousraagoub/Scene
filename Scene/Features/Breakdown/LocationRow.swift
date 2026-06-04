//
//  LocationRow.swift
//  Scene
//

import SwiftUI

struct LocationRow: View {

    let location: LocationBreakdown

    var body: some View {

        HStack {

            VStack(
                alignment: .leading,
                spacing: 4
            ) {

                Text(location.name)
                    .foregroundStyle(.white)

                Text(location.type)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding()
        .background(
            Color.white.opacity(0.04)
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 16
            )
        )
    }
}
