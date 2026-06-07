import SwiftUI

struct BreakdownView: View {

    @Binding var breakdown: ScriptBreakdown
    var onCostChange: (String, Double) -> Void = { _, _ in }

    @State private var selectedSceneIndex = 0
    @State private var showBudget = false
    @AppStorage("userName") private var userName: String = ""

    var body: some View {

        VStack(spacing: 16) {

            // MARK: - Top Bar

            HStack {

                if !showBudget {
                    SceneNavigationView(
                        sceneIndex: $selectedSceneIndex,
                        totalScenes: breakdown.scenes.count
                    )
                }

                Spacer()

                Picker("", selection: $showBudget) {
                    Text("Breakdown").tag(false)
                    Text("Budget").tag(true)
                }
                .pickerStyle(.segmented)
                .tint(.white)
                .frame(width: 220)
            }

            if showBudget {
                BudgetView(breakdown: $breakdown, onCostChange: onCostChange)
            } else {
                breakdownContent(breakdown: breakdown)
            }
        }
    }
}

// MARK: - Breakdown Content

extension BreakdownView {

    @ViewBuilder
    func breakdownContent(breakdown: ScriptBreakdown) -> some View {

        if breakdown.scenes.isEmpty || !breakdown.scenes.indices.contains(selectedSceneIndex) {
            ContentUnavailableView("No Scenes", systemImage: "film")
        } else {

            let scene = breakdown.scenes[selectedSceneIndex]

            ScrollView {
                VStack(spacing: 20) {
                    summaryRow(scene: scene, sceneNumber: selectedSceneIndex + 1)
                    sectionsGrid(scene: scene, breakdown: breakdown)
                }
                .padding(.bottom, 24)
            }
        }
    }

    // MARK: Summary Cards

    @ViewBuilder
    func summaryRow(scene: SceneBreakdown, sceneNumber: Int) -> some View {
        HStack(spacing: 12) {

            SummaryCard(title: "Scene",      count: sceneNumber,            icon: "film.fill",      color: .white)

            if !scene.characters.isEmpty {
                SummaryCard(title: "Characters", count: scene.characters.count, icon: "person.3.fill", color: .indigo)
            }
            if !scene.locations.isEmpty {
                SummaryCard(title: "Locations",  count: scene.locations.count,  icon: "location.fill", color: .cyan)
            }
            if !scene.props.isEmpty {
                SummaryCard(title: "Props",      count: scene.props.count,      icon: "shippingbox.fill", color: .orange)
            }
            if !scene.vehicles.isEmpty {
                SummaryCard(title: "Vehicles",   count: scene.vehicles.count,   icon: "car.fill",      color: .blue)
            }
            if !scene.equipment.isEmpty {
                SummaryCard(title: "Equipment",  count: scene.equipment.count,  icon: "camera.fill",   color: .yellow)
            }
        }
    }

    @ViewBuilder
    func sectionsGrid(scene: SceneBreakdown, breakdown: ScriptBreakdown) -> some View {
 
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ],
            alignment: .leading,
            spacing: 16
        ) {
 
            if !scene.characters.isEmpty {
                SectionCard(title: "Characters", icon: "person.3.fill", iconColor: .indigo) {
                    CollapsibleRows(items: scene.characters) { character in
                        EntityDetailRow(
                            name: character.name,
                            detail: "",
                            icon: "person.fill",
                            iconColor: .indigo,
                            sceneCount: sceneCount(entityId: character.id, in: breakdown.scenes) {
                                $0.characters.contains { $0.id == character.id }
                            }
                        )
                    }
                }
            }
 
            if !scene.locations.isEmpty {
                SectionCard(title: "Locations", icon: "location.fill", iconColor: .cyan) {
                    CollapsibleRows(items: scene.locations) { location in
                        EntityDetailRow(
                            name: location.name,
                            detail: location.type,
                            icon: "location.fill",
                            iconColor: .cyan,
                            sceneCount: sceneCount(entityId: location.id, in: breakdown.scenes) {
                                $0.locations.contains { $0.id == location.id }
                            }
                        )
                    }
                }
            }
 
            if !scene.props.isEmpty {
                SectionCard(title: "Props", icon: "shippingbox.fill", iconColor: .orange) {
                    ChipGrid(items: scene.props.map(\.name), color: .orange)
                }
            }
 
            if !scene.setDressing.isEmpty {
                SectionCard(title: "Set Dressing", icon: "sofa.fill", iconColor: .brown) {
                    ChipGrid(items: scene.setDressing, color: .brown)
                }
            }
 
            if !scene.vehicles.isEmpty {
                SectionCard(title: "Vehicles", icon: "car.fill", iconColor: .blue) {
                    CollapsibleRows(items: scene.vehicles) { vehicle in
                        EntityDetailRow(
                            name: vehicle.name,
                            detail: vehicle.type,
                            icon: "car.fill",
                            iconColor: .blue,
                            sceneCount: sceneCount(entityId: vehicle.id, in: breakdown.scenes) {
                                $0.vehicles.contains { $0.id == vehicle.id }
                            }
                        )
                    }
                }
            }
 
            if !scene.animals.isEmpty {
                SectionCard(title: "Animals", icon: "hare.fill", iconColor: .green) {
                    CollapsibleRows(items: scene.animals) { animal in
                        EntityDetailRow(
                            name: animal.name,
                            detail: "",
                            icon: "hare.fill",
                            iconColor: .green,
                            sceneCount: sceneCount(entityId: animal.id, in: breakdown.scenes) {
                                $0.animals.contains { $0.id == animal.id }
                            }
                        )
                    }
                }
            }
 
            if !scene.wardrobe.isEmpty {
                SectionCard(title: "Wardrobe", icon: "tshirt.fill", iconColor: .pink) {
                    ChipGrid(items: scene.wardrobe.map(\.name), color: .pink)
                }
            }
 
            if !scene.makeup.isEmpty {
                SectionCard(title: "Makeup", icon: "paintbrush.fill", iconColor: .red) {
                    ChipGrid(items: scene.makeup.map(\.name), color: .red)
                }
            }
 
            if !scene.equipment.isEmpty {
                SectionCard(title: "Equipment", icon: "camera.fill", iconColor: .yellow) {
                    CollapsibleRows(items: scene.equipment) { item in
                        EntityDetailRow(
                            name: item.name,
                            detail: item.department,
                            icon: "camera.fill",
                            iconColor: .yellow,
                            sceneCount: sceneCount(entityId: item.id, in: breakdown.scenes) {
                                $0.equipment.contains { $0.id == item.id }
                            }
                        )
                    }
                }
            }
 
            if !scene.vfx.isEmpty || !scene.sfx.isEmpty || !scene.sound.isEmpty || !scene.music.isEmpty {
                SectionCard(title: "Post Production", icon: "sparkles", iconColor: .purple) {
                    if !scene.vfx.isEmpty   { PostChipGroup(label: "VFX",   items: scene.vfx,   color: .indigo) }
                    if !scene.sfx.isEmpty   { PostChipGroup(label: "SFX",   items: scene.sfx,   color: .purple) }
                    if !scene.sound.isEmpty { PostChipGroup(label: "Sound", items: scene.sound, color: .blue) }
                    if !scene.music.isEmpty { PostChipGroup(label: "Music", items: scene.music, color: .pink) }
                }
            }
        }
    }

    func sceneCount(
        entityId: String,
        in scenes: [SceneBreakdown],
        matching: (SceneBreakdown) -> Bool
    ) -> Int {
        scenes.filter(matching).count
    }
}

// MARK: - Section Card

struct SectionCard<Content: View>: View {

    let title: String
    let icon: String
    var iconColor: Color = .white
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.15))
                        .frame(width: 30, height: 30)
                    Image(systemName: icon)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(iconColor.opacity(0.7))
                }
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.white)
                Spacer()
            }
            content
            Spacer(minLength: 0) // pushes content to top when card stretches
        }
        .padding(16)
        // maxHeight: .infinity — lets the card fill the row height set by its taller neighbour
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .glassEffect(in: RoundedRectangle(cornerRadius: 24))
    }
}

// MARK: - Entity Detail Row

struct EntityDetailRow: View {

    let name:       String
    let detail:     String
    let icon:       String
    let iconColor:  Color
    let sceneCount: Int

    var body: some View {
        HStack(spacing: 10) {

            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.12))
                    .frame(width: 28, height: 28)
                Image(systemName: icon)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(iconColor.opacity(0.7))
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
                if !detail.isEmpty {
                    Text(detail.capitalized)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            if sceneCount > 0 {
                Text("\(sceneCount) scenes")
                    .font(.system(size: 8, weight: .medium))
                    .foregroundStyle(iconColor.opacity(0.8))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 6)
                    .background(iconColor.opacity(0.12))
                    .clipShape(Capsule())
            }
        }
        .padding(10)
        .glassEffect(in: RoundedRectangle(cornerRadius: 24))
    }
}

// MARK: - Chip Grid

struct ChipGrid: View {

    let items: [String]
    var color: Color = .white

    var body: some View {
        LazyVGrid(
            columns: [GridItem(.adaptive(minimum: 64), spacing: 4)],
            alignment: .leading,
            spacing: 6
        ) {
            ForEach(items, id: \.self) { item in
                Text(item)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(color.opacity(0.8))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .minimumScaleFactor(0.7)
                    .lineLimit(1)
                    .background(color.opacity(0.12))
                    .clipShape(Capsule())
            }
        }
    }
}

// MARK: - Post Chip Group

struct PostChipGroup: View {

    let label: String
    let items: [String]
    var color: Color = .white

    var body: some View {
        VStack(alignment: .leading) {
//            if !label.isEmpty {
//                Text(label)
//                    .font(.caption)
//                    .fontWeight(.semibold)
//                    .foregroundStyle(color.opacity(0.7))
//            }
            ChipGrid(items: items, color: color)
        }
    }
}


// MARK: - CollapsibleRows
//
// Shows up to 3 rows by default. If there are more, a button
// reveals the rest in place — no nested ScrollView needed.
 
struct CollapsibleRows<Item: Identifiable, Row: View>: View {
 
    let items: [Item]
    var maxVisible: Int = 3
    @ViewBuilder let row: (Item) -> Row
 
    @State private var showAll = false
 
    private var visibleItems: [Item] {
        showAll ? items : Array(items.prefix(maxVisible))
    }
 
    var body: some View {
        VStack(spacing: 8) {
            ForEach(visibleItems) { item in
                row(item)
            }
            if items.count > maxVisible {
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showAll.toggle()
                    }
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: showAll ? "chevron.up" : "chevron.down")
                            .font(.system(size: 9, weight: .semibold))
                        Text(showAll ? "Show less" : "+\(items.count - maxVisible) more")
                            .font(.caption)
                    }
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 2)
                }
                .buttonStyle(.plain)
            }
        }
    }
}
