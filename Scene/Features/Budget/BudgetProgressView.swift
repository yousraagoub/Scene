//
//  BudgetProgressView.swift
//  Scene
//
import SwiftUI

struct BudgetProgressView: View {

    let completedItems: Int
    let totalItems: Int
    let totalBudget: Double

    private var progress: Double {
        guard totalItems > 0 else { return 0 }
        return Double(completedItems) / Double(totalItems)
    }

    var body: some View {

        VStack(spacing: 16) {
               

            // Progress ring — scales to available width
            GeometryReader { geo in
                let size = geo.size.width
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.15), lineWidth: 10)

                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(
                            Color.primaryRed,
                            style: StrokeStyle(lineWidth: 10, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut, value: progress)

                    VStack(spacing: 4) {
                        Text("\(completedItems)")
                            .font(.system(size: size * 0.18, weight: .bold))
                            .foregroundStyle(.white)
                        Text("of \(totalItems)")
                            .font(.system(size: size * 0.1))
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(24)
                .frame(width: size, height: size)
            }
            .aspectRatio(1, contentMode: .fit)

            // Total budget card
            VStack(spacing: 6) {
                Text("Total Budget")
                    .font(.title)
                    .foregroundStyle(.secondary)

                HStack(spacing: 4) {
                    Image("riyalSign")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                    Text("\(Int(totalBudget))")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .glassEffect(in: RoundedRectangle(cornerRadius: 20))
        }
        .padding(40)
        .frame(maxWidth: .infinity)
        .glassEffect(in: RoundedRectangle(cornerRadius: 24))
    }
}
