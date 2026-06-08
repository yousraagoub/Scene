//
//  BreakdownSectionCard.swift
//  Scene
//
import SwiftUI

struct BreakdownSectionCard<Content: View>: View {

    let title: String
    let icon: String
    let color: Color

    @ViewBuilder let content: Content

    var body: some View {

        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Label(title, systemImage: icon)
                    .font(.title2)
                    .foregroundStyle(color)
                Spacer()
            }
            content
        }
        .padding()
        .glassEffect(
            in: RoundedRectangle(cornerRadius: 30)
        )
    }
}

