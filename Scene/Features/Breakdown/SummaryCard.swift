//
//  SummaryCard.swift
//  Scene
//
import SwiftUI

struct SummaryCard: View {

    let title: String
    let count: Int
    let icon:  String
    var color: Color = .white

    var body: some View {

        VStack(alignment: .leading, spacing: 0) {

            // Icon circle — top trailing
            HStack() {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 60, height: 60)
                        .glassEffect(.clear)
                    Image(systemName: icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36, height: 36)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(color.opacity(0.7))
                }
                Text(title)
                    .font(.largeTitle)
                    .foregroundStyle(.secondary)
                    .padding(.top, 2)
                Spacer()
            }

            Spacer()

            // Count
            HStack(){
                Spacer()
                Text("\(count)")
                    .font(.system(size: 40, weight: .bold))
                    .dynamicTypeSize(.accessibility5)
                    .foregroundStyle(.white)
            }

            // Label
            
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .frame(height: 130)
        .glassEffect(in: RoundedRectangle(cornerRadius: 24))
    }
}

