//
//  BudgetView.swift
//  Scene
//
import SwiftUI

struct BudgetView: View {

    @Binding var breakdown: ScriptBreakdown
    var onCostChange: (String, Double) -> Void = { _, _ in }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {

                budgetSection(
                    title: "Cast",
                    icon: "person.3.fill",
                    indices: breakdown.totalCharacters.indices,
                    id:   { breakdown.totalCharacters[$0].id },
                    name: { breakdown.totalCharacters[$0].name },
                    cost: { $breakdown.totalCharacters[$0].cost }
                )

                budgetSection(
                    title: "Locations",
                    icon: "location.fill",
                    indices: breakdown.totalLocations.indices,
                    id:   { breakdown.totalLocations[$0].id },
                    name: { breakdown.totalLocations[$0].name },
                    cost: { $breakdown.totalLocations[$0].cost }
                )

                budgetSection(
                    title: "Props",
                    icon: "shippingbox.fill",
                    indices: breakdown.totalProps.indices,
                    id:   { breakdown.totalProps[$0].id },
                    name: { breakdown.totalProps[$0].name },
                    cost: { $breakdown.totalProps[$0].cost }
                )

                budgetSection(
                    title: "Vehicles",
                    icon: "car.fill",
                    indices: breakdown.totalVehicles.indices,
                    id:   { breakdown.totalVehicles[$0].id },
                    name: { breakdown.totalVehicles[$0].name },
                    cost: { $breakdown.totalVehicles[$0].cost }
                )

                budgetSection(
                    title: "Animals",
                    icon: "hare.fill",
                    indices: breakdown.totalAnimals.indices,
                    id:   { breakdown.totalAnimals[$0].id },
                    name: { breakdown.totalAnimals[$0].name },
                    cost: { $breakdown.totalAnimals[$0].cost }
                )

                budgetSection(
                    title: "Wardrobe",
                    icon: "tshirt.fill",
                    indices: breakdown.totalWardrobe.indices,
                    id:   { breakdown.totalWardrobe[$0].id },
                    name: { breakdown.totalWardrobe[$0].name },
                    cost: { $breakdown.totalWardrobe[$0].cost }
                )

                budgetSection(
                    title: "Makeup",
                    icon: "paintbrush.fill",
                    indices: breakdown.totalMakeup.indices,
                    id:   { breakdown.totalMakeup[$0].id },
                    name: { breakdown.totalMakeup[$0].name },
                    cost: { $breakdown.totalMakeup[$0].cost }
                )

                budgetSection(
                    title: "Equipment",
                    icon: "camera.fill",
                    indices: breakdown.totalEquipment.indices,
                    id:   { breakdown.totalEquipment[$0].id },
                    name: { breakdown.totalEquipment[$0].name },
                    cost: { $breakdown.totalEquipment[$0].cost }
                )

                // Total row
                VStack(spacing: 0) {
                    Divider()
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Total Budget")
                                .font(.headline)
                                .foregroundStyle(.white)
                            Text("\(totalEntityCount) items")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text(breakdown.totalBudget, format: .currency(code: "SAR"))
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                    }
                    .padding()
                }
            }
            .padding()
        }
    }

    private var totalEntityCount: Int {
        breakdown.totalCharacters.count +
        breakdown.totalLocations.count +
        breakdown.totalProps.count +
        breakdown.totalVehicles.count +
        breakdown.totalAnimals.count +
        breakdown.totalWardrobe.count +
        breakdown.totalMakeup.count +
        breakdown.totalEquipment.count
    }

    // MARK: - Helper Functions
    
    private func iconColor(for icon: String) -> Color {
        switch icon {
        case "person.3.fill":
            return .indigo
        case "location.fill":
            return .cyan
        case "shippingbox.fill":
            return .orange
        case "car.fill":
            return .blue
        case "hare.fill":
            return .green
        case "tshirt.fill":
            return .pink
        case "paintbrush.fill":
            return .red
        case "camera.fill":
            return .yellow
        default:
            return .secondary
        }
    }

    // MARK: - Section Builder

    @ViewBuilder
    private func budgetSection(
        title: String,
        icon: String,
        indices: Range<Int>,
        id:   @escaping (Int) -> String,
        name: @escaping (Int) -> String,
        cost: @escaping (Int) -> Binding<Double>
    ) -> some View {
        if !indices.isEmpty {
            VStack(alignment: .leading, spacing: 10) {

                // Section header
                HStack(spacing: 8) {
                    Image(systemName: icon)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(iconColor(for: icon))
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text("\(indices.count) item\(indices.count == 1 ? "" : "s")")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
                .padding(.horizontal, 4)

                // Rows
                VStack(spacing: 6) {
                    ForEach(indices, id: \.self) { i in
                        BudgetItemRow(
                            entityId: id(i),
                            name: name(i),
                            cost: cost(i),
                            onCostChange: onCostChange
                        )
                    }
                }
            }
        }
    }
}

// MARK: - BudgetItemRow

struct BudgetItemRow: View {

    let entityId: String
    let name: String
    @Binding var cost: Double
    var onCostChange: (String, Double) -> Void = { _, _ in }

    @State private var text = ""

    var body: some View {
        HStack {
            Text(name)
                .font(.subheadline)
                .foregroundStyle(.white)
            Spacer()
            HStack(spacing: 4) {
                Text("SAR")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                TextField("0", text: $text)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 90)
                    .onChange(of: text) { _, newValue in
                        let newCost = Double(newValue) ?? 0
                        cost = newCost
                        onCostChange(entityId, newCost)
                    }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(Color.white.opacity(0.04))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .onAppear {
            text = cost == 0 ? "" : String(cost)
        }
    }
}
