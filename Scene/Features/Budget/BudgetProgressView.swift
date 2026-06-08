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

        VStack(spacing: 24) {

            ZStack {

                Circle()
                    .stroke(
                        Color.white.opacity(0.15),
                        lineWidth: 12
                    )

                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        Color.primaryRed,
                        style: StrokeStyle(
                            lineWidth: 12,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut, value: progress)

                VStack(spacing: 4) {

                    Text("\(completedItems)")
                        .font(.largeTitle)
                        .bold()
                        .foregroundStyle(.white)

                    Text(String(localized:"of \(totalItems)"))
                        .font(.title2)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(width: 500, height: 700)

            VStack(spacing: 8) {

                Text("Total Budget")
                    .font(.largeTitle)
                    .foregroundStyle(.secondary)

                HStack{
                    Image("riyalSign")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                    Text("\(Int(totalBudget))")
                        .font(.largeTitle)
                        .bold()
                        .foregroundStyle(.white)
                }
            }
            .padding()
            .glassEffect(
                in: RoundedRectangle(cornerRadius: 24)
            )

            
        }
        .frame(width: 600, height: 800)
        .padding()
        .glassEffect(
            in: RoundedRectangle(cornerRadius: 24)
        )
        
    }
}
