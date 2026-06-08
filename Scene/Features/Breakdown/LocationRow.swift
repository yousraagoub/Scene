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
                    .font(.title2)
                    .foregroundStyle(.white)
//
//                Text(location.type)
//                    .font(.caption)
//                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding()
        .glassEffect(
            in: RoundedRectangle(cornerRadius: 16)
        )
        .shadow(color: Color.locatioinCard.opacity(0.3), radius: 4)
    }
}
