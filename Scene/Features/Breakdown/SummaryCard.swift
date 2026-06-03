//
//  SummaryCard.swift
//  Scene
//
import SwiftUI

struct SummaryCard: View {

    let title: String

    let count: Int

    let icon: String

    var body: some View {

        VStack(alignment: .leading) {

            HStack {

                Label(title, systemImage: icon)
                    .foregroundStyle(.secondary)

                Spacer()
            }

            Spacer()

            Text("\(count)")
                .font(.system(size: 42, weight: .bold))
                .foregroundStyle(.white)
        }
        .padding(20)
        .frame(height: 150)
        .glassEffect(
            in: RoundedRectangle(cornerRadius: 24)
        )
    }
}

