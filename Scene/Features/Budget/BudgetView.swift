//
//  BudgetView.swift
//  Scene
//
import SwiftUI

struct BudgetView: View {

    @Binding var breakdown: ScriptBreakdown
    var onCostChange: (String, Double) -> Void = { _, _ in }

    var body: some View {
        HStack(alignment: .top, spacing: 20) {

            // MARK: - Left: Budget Items
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
                }
                .padding(40)
                .frame(maxWidth: .infinity)
                .glassEffect(in: RoundedRectangle(cornerRadius: 24))
                //.padding()
            }
            Spacer()

            // MARK: - Right: Progress Summary
            VStack{
                BudgetDonutChartView(
                    breakdown: breakdown
                )
                .frame(maxWidth: 580)
                Spacer()
            }
            Spacer()
        }
    }

    // MARK: - Computed

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

    // Items that have had a cost entered (cost > 0)
    private var completedItems: Int {
        let charactersCount = breakdown.totalCharacters.filter { $0.cost > 0 }.count
        let locationsCount = breakdown.totalLocations.filter { $0.cost > 0 }.count
        let propsCount = breakdown.totalProps.filter { $0.cost > 0 }.count
        let vehiclesCount = breakdown.totalVehicles.filter { $0.cost > 0 }.count
        let animalsCount = breakdown.totalAnimals.filter { $0.cost > 0 }.count
        let wardrobeCount = breakdown.totalWardrobe.filter { $0.cost > 0 }.count
        let makeupCount = breakdown.totalMakeup.filter { $0.cost > 0 }.count
        let equipmentCount = breakdown.totalEquipment.filter { $0.cost > 0 }.count
        
        return charactersCount + locationsCount + propsCount + vehiclesCount +
               animalsCount + wardrobeCount + makeupCount + equipmentCount
    }

    // MARK: - Icon color helper

    private func iconColor(for icon: String) -> Color {
        switch icon {
        case "person.3.fill":  return .indigo
        case "location.fill":  return .cyan
        case "shippingbox.fill": return .orange
        case "car.fill":       return .blue
        case "hare.fill":      return .green
        case "tshirt.fill":    return .pink
        case "paintbrush.fill": return .red
        case "camera.fill":    return .yellow
        default:               return .secondary
        }
    }

    // MARK: - Section builder

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

                HStack(spacing: 8) {
                    Image(systemName: icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 17, height: 17)
                        .foregroundStyle(iconColor(for: icon))
                        .shadow(color: iconColor(for: icon), radius: 20)
                    Text(title)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text("\(indices.count) item\(indices.count == 1 ? "" : "s")")
                        .font(.title2)
                        .foregroundStyle(.tertiary)
                }
                .padding(.horizontal, 4)

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
    @State private var showSaved = false
    
    // Number formatter for validation
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.allowsFloats = true
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    var body: some View {
        HStack {
            Text(name)
                .font(.title3)
                .foregroundStyle(.white)
            
            Spacer()
            
            if showSaved {
                Text("Saved")
                    .font(.caption)
                    .foregroundStyle(.green)
                    .transition(.opacity)
            }
            
            HStack(spacing: 4) {
                TextField("0", text: $text)
                    .multilineTextAlignment(.trailing)
                    .font(.title2)
                    .frame(width: 90)
                    .onChange(of: text) { _, newValue in
                        
                        // Filter to only allow numbers and decimal point
                        let filtered = newValue.filter {
                            "0123456789.".contains($0)
                        }
                        
                        // Prevent multiple decimal points
                        let components = filtered.components(separatedBy: ".")
                        
                        let finalText = components.count > 2
                        ? components[0] + "." + components[1]
                        : filtered
                        
                        if finalText != newValue {
                            text = finalText
                        }
                        
                        let newCost = Double(finalText) ?? 0
                        
                        cost = newCost
                        onCostChange(entityId, newCost)
                        
                        // MARK: Saved feedback
                        
                        withAnimation {
                            showSaved = true
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation {
                                showSaved = false
                            }
                        }
                    }
                
                Image("riyalSign")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 17, height: 17)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 17)
        .padding(.vertical, 10)
        .glassEffect(in: RoundedRectangle(cornerRadius: 20))
        .shadow(color: .gray.opacity(0.2), radius: 1)
        .onAppear {
            text = cost == 0 ? "" : String(cost)
        }
    }
}


//MARK: For Preview Only.
#Preview {
    PreviewBudgetView()
}

private struct PreviewBudgetView: View {

    @State private var breakdown = ScriptBreakdown(
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
            ),
            LocationBreakdown(
                id: "loc_002",
                name: "Rooftop",
                type: "Exterior",
                cost: 2000
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
        BudgetView(breakdown: $breakdown)
            .frame(width: 1400, height: 900)
            .padding()
            .preferredColorScheme(.dark)
    }
}
