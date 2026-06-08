//
//  CharacterRow.swift
//  Scene
//

import SwiftUI

struct CharacterRow: View {

    let character: CharacterBreakdown

    var body: some View {

        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(character.name)
                    .font(.title2)
                    .foregroundStyle(.white)
            }
            Spacer()
        }
        .padding()
        .glassEffect(
            in: RoundedRectangle(cornerRadius: 16)
        )
        .shadow(color: Color.characterCard.opacity(0.3), radius: 4)
    }
}
