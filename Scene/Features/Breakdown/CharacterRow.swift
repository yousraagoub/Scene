//
//  CharacterRow.swift
//  Scene
//

import SwiftUI

struct CharacterRow: View {

    let character: CharacterBreakdown

    var body: some View {

        HStack {

            VStack(
                alignment: .leading,
                spacing: 4
            ) {

                Text(character.name)
                    .font(.subheadline)
                    .fontWeight(.medium)

//                if let state = character.stateInScene.first {
//                    Text(state.capitalized)
//                        .font(.caption)
//                        .foregroundStyle(.secondary)
//                }
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
