//
//  BudgetDonutChartView.swift
//  Scene
//
//  Created by Yousra Abdelrahman on 08/01/1448 AH.
//

import SwiftUI

struct BudgetDonutChartView: View {

    let breakdown: ScriptBreakdown
    private let segmentSpacing: Double = 5 // degrees

    @State private var selectedIndex = 0

    // MARK: - Categories

    private var categories: [BudgetCategory] {
        [
            BudgetCategory(
                name: "Cast",
                amount: breakdown.totalCharacters.map(\.cost).reduce(0, +),
                color: .indigo,
                icon: "person.3.fill"
            ),
            BudgetCategory(
                name: "Locations",
                amount: breakdown.totalLocations.map(\.cost).reduce(0, +),
                color: .cyan,
                icon: "location.fill"
            ),
            BudgetCategory(
                name: "Props",
                amount: breakdown.totalProps.map(\.cost).reduce(0, +),
                color: .orange,
                icon: "shippingbox.fill"
            ),
            BudgetCategory(
                name: "Vehicles",
                amount: breakdown.totalVehicles.map(\.cost).reduce(0, +),
                color: .blue,
                icon: "car.fill"
            ),
            BudgetCategory(
                name: "Animals",
                amount: breakdown.totalAnimals.map(\.cost).reduce(0, +),
                color: .green,
                icon: "hare.fill"
            ),
            BudgetCategory(
                name: "Wardrobe",
                amount: breakdown.totalWardrobe.map(\.cost).reduce(0, +),
                color: .pink,
                icon: "tshirt.fill"
            ),
            BudgetCategory(
                name: "Makeup",
                amount: breakdown.totalMakeup.map(\.cost).reduce(0, +),
                color: .red,
                icon: "paintbrush.fill"
            ),
            BudgetCategory(
                name: "Equipment",
                amount: breakdown.totalEquipment.map(\.cost).reduce(0, +),
                color: .yellow,
                icon: "camera.fill"
            )
        ]
        .filter { $0.amount > 0 }
    }

    private var totalBudget: Double {
        categories.map(\.amount).reduce(0, +)
    }

    private var selectedCategory: BudgetCategory? {
        guard categories.indices.contains(selectedIndex) else { return nil }
        return categories[selectedIndex]
    }

    // MARK: - Body

    var body: some View {

        VStack {
            

            GeometryReader { geo in

                let size = geo.size.width
                Text("Distribution")
                    .font(.title)
                    .foregroundStyle(.white)
                    .padding()
                ZStack {

                    ForEach(Array(categories.enumerated()), id: \.offset) { index, category in

                        let start = startAngle(for: index)
                        let end = endAngle(for: index)

                        BudgetSegmentShape(
                            startAngle: start,
                            endAngle: end
                        )
                        .stroke(
                            category.color.opacity( selectedIndex == index ? 1 : 0.3),
                            style: StrokeStyle(
                                lineWidth: selectedIndex == index ? 18 : 12,
                                lineCap: .round
                            )
                        )
                        .animation(.spring(duration: 0.3), value: selectedIndex)
                        .onTapGesture {
                            selectedIndex = index
                        }
                    }

                    // MARK: Center

                    VStack(spacing: 8) {
                        Image(systemName: selectedCategory? .icon ?? "Icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(selectedCategory?.color ?? .white)
                            .shadow(color: selectedCategory?.color ?? .white, radius: 20)

                        
                        HStack(spacing: 6) {

                            Image("riyalSign")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 22, height: 22)

                            Text("\(Int(selectedCategory?.amount ?? totalBudget))")
                                .font(.largeTitle)
                                .foregroundStyle(.white)
                        }
                        Text(selectedCategory?.name ?? "Budget")
                            .font(.title)

                

                    }
                }
                .padding(35)
                .frame(width: size, height: size)
            }
            .aspectRatio(1, contentMode: .fit)
            .glassEffect(in: RoundedRectangle(cornerRadius: 24))

            Spacer()

            // MARK: Total Budget Card

            VStack(spacing: 5) {

                HStack {

                    Text("Total Budget")
                        .font(.largeTitle)
                        .foregroundStyle(.white)

                    Spacer()
                }
                .padding(.bottom, 20)

                HStack(spacing: 10) {

                    Spacer()

                    Image("riyalSign")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)

                    Text("\(Int(totalBudget))")
                        .font(.system(size: 60))
                        .foregroundStyle(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.primaryRed)
            )
            .glassEffect(in: RoundedRectangle(cornerRadius: 20))

            Spacer()
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Angles

    private func startAngle(for index: Int) -> Angle {

        let previousAmount = categories
            .prefix(index)
            .map(\.amount)
            .reduce(0, +)

        return .degrees(
            (previousAmount / totalBudget) * 360 - 90 + segmentSpacing / 2
        )
    }

    private func endAngle(for index: Int) -> Angle {

        let currentAmount = categories
            .prefix(index + 1)
            .map(\.amount)
            .reduce(0, +)

        return .degrees(
            (currentAmount / totalBudget) * 360 - 90 - segmentSpacing / 2
        )
    }
}
//
//#Preview {
//
//    PreviewBudgetView()
//}

// MARK: For Preview Only

#Preview("Budget Donut Chart") {
    PreviewBudgetDonutChartView()
}

private struct PreviewBudgetDonutChartView: View {

    private let breakdown = ScriptBreakdown(
        scenes: [],
        totalCharacters: [
            CharacterBreakdown(
                id: "char_001",
                name: "Sarah",
                aliases: [],
                cost: 3500
            ),
            CharacterBreakdown(
                id: "char_002",
                name: "Omar",
                aliases: [],
                cost: 2200
            )
        ],
        totalLocations: [
            LocationBreakdown(
                id: "loc_001",
                name: "Coffee Shop",
                type: "Interior",
                cost: 1500
            )
        ],
        totalProps: [
            PropBreakdown(
                id: "prop_001",
                name: "Laptop",
                category: "Electronics",
                cost: 800
            ),
            PropBreakdown(
                id: "prop_002",
                name: "Notebook",
                category: "Stationery",
                cost: 100
            )
        ],
        totalVehicles: [
            VehicleBreakdown(
                id: "veh_001",
                name: "Toyota Camry",
                type: "Car",
                cost: 500
            )
        ],
        totalAnimals: [
            AnimalBreakdown(
                id: "ani_001",
                name: "Golden Retriever",
                cost: 300
            )
        ],
        totalWardrobe: [
            WardrobeBreakdown(
                id: "war_001",
                name: "Police Uniform",
                cost: 400
            )
        ],
        totalMakeup: [
            MakeupBreakdown(
                id: "make_001",
                name: "Special Effects Makeup",
                cost: 650
            )
        ],
        totalEquipment: [
            EquipmentBreakdown(
                id: "eq_001",
                name: "Sony FX3",
                department: "Camera",
                cost: 4500
            ),
            EquipmentBreakdown(
                id: "eq_002",
                name: "Boom Microphone",
                department: "Sound",
                cost: 900
            )
        ],
        totalVFX: [],
        totalSFX: []
    )

    var body: some View {
        BudgetDonutChartView(
            breakdown: breakdown
        )
        .frame(width: 450, height: 650)
        .padding()
        .preferredColorScheme(.dark)
    }
}
