import SwiftUI

struct BreakdownView: View {

    @Binding var breakdown: ScriptBreakdown
    var onCostChange: (String, Double) -> Void = { _, _ in }

    @State private var selectedSceneIndex = 0
    @State private var showBudget = false

    var body: some View {

        VStack(spacing: 16) {

            // MARK: - Top Bar

            HStack {

                // Scene navigation — left side
                if !showBudget {
                    SceneNavigationView(
                        sceneIndex: $selectedSceneIndex,
                        totalScenes: breakdown.scenes.count
                    )
                }

                Spacer()

                // Breakdown / Budget toggle — right side
                Picker("", selection: $showBudget) {
                    Text("Breakdown").tag(false)
                    Text("Budget").tag(true)
                }
                .pickerStyle(.segmented)
                .tint(.white)
                .frame(width: 220)
            }

            // MARK: - Content

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

            SummaryCard(
                title: "Scene",
                count: sceneNumber,
                icon: "film.fill",
                color: .white
            )

            if !scene.characters.isEmpty {
                SummaryCard(
                    title: "Characters",
                    count: scene.characters.count,
                    icon: "person.3.fill",
                    color: Color.indigo
                )
            }

            if !scene.locations.isEmpty {
                SummaryCard(
                    title: "Locations",
                    count: scene.locations.count,
                    icon: "location.fill",
                    color: Color.cyan
                )
            }

            if !scene.props.isEmpty {
                SummaryCard(
                    title: "Props",
                    count: scene.props.count,
                    icon: "shippingbox.fill",
                    color: Color.orange
                )
            }

            if !scene.vehicles.isEmpty {
                SummaryCard(
                    title: "Vehicles",
                    count: scene.vehicles.count,
                    icon: "car.fill",
                    color: Color.blue
                )
            }

            if !scene.equipment.isEmpty {
                SummaryCard(
                    title: "Equipment",
                    count: scene.equipment.count,
                    icon: "camera.fill",
                    color: Color.yellow
                )
            }
        }
    }

    // MARK: Sections Grid

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

            // MARK: Characters

            if !scene.characters.isEmpty {
                SectionCard(
                    title: "Characters",
                    icon: "person.3.fill",
                    iconColor: .indigo
                ) {
                    ForEach(scene.characters) { character in
                        EntityDetailRow(
                            name: character.name,
                            detail: "",
                            icon: "person.fill",
                            iconColor: .indigo,
                            sceneCount: sceneCount(
                                entityId: character.id,
                                in: breakdown.scenes,
                                matching: {
                                    $0.characters.contains { $0.id == character.id }
                                }
                            )
                        )
                    }
                }
            }

            // MARK: Locations

            if !scene.locations.isEmpty {
                SectionCard(
                    title: "Locations",
                    icon: "location.fill",
                    iconColor: .cyan
                ) {
                    ForEach(scene.locations) { location in
                        EntityDetailRow(
                            name: location.name,
                            detail: location.type,
                            icon: "location.fill",
                            iconColor: .cyan,
                            sceneCount: sceneCount(
                                entityId: location.id,
                                in: breakdown.scenes,
                                matching: {
                                    $0.locations.contains { $0.id == location.id }
                                }
                            )
                        )
                    }
                }
            }

            // MARK: Props

            if !scene.props.isEmpty {
                SectionCard(
                    title: "Props",
                    icon: "shippingbox.fill",
                    iconColor: .orange
                ) {
                    ChipGrid(
                        items: scene.props.map(\.name),
                        color: .orange
                    )
                }
            }

            // MARK: Set Dressing

            if !scene.setDressing.isEmpty {
                SectionCard(
                    title: "Set Dressing",
                    icon: "sofa.fill",
                    iconColor: .brown
                ) {
                    ChipGrid(
                        items: scene.setDressing,
                        color: .brown
                    )
                }
            }

            // MARK: Vehicles

            if !scene.vehicles.isEmpty {
                SectionCard(
                    title: "Vehicles",
                    icon: "car.fill",
                    iconColor: .blue
                ) {
                    ForEach(scene.vehicles) { vehicle in
                        EntityDetailRow(
                            name: vehicle.name,
                            detail: "",
                            icon: "car.fill",
                            iconColor: .blue,
                            sceneCount: sceneCount(
                                entityId: vehicle.id,
                                in: breakdown.scenes,
                                matching: {
                                    $0.vehicles.contains { $0.id == vehicle.id }
                                }
                            )
                        )
                    }
                }
            }

            // MARK: Animals

            if !scene.animals.isEmpty {
                SectionCard(
                    title: "Animals",
                    icon: "hare.fill",
                    iconColor: .green
                ) {
                    ForEach(scene.animals) { animal in
                        EntityDetailRow(
                            name: animal.name,
                            detail: "",
                            icon: "hare.fill",
                            iconColor: .green,
                            sceneCount: sceneCount(
                                entityId: animal.id,
                                in: breakdown.scenes,
                                matching: {
                                    $0.animals.contains { $0.id == animal.id }
                                }
                            )
                        )
                    }
                }
            }

            // MARK: Wardrobe

            if !scene.wardrobe.isEmpty {
                SectionCard(
                    title: "Wardrobe",
                    icon: "tshirt.fill",
                    iconColor: .pink
                ) {
                    ChipGrid(
                        items: scene.wardrobe.map(\.name),
                        color: .pink
                    )
                }
            }

            // MARK: Makeup

            if !scene.makeup.isEmpty {
                SectionCard(
                    title: "Makeup",
                    icon: "paintbrush.fill",
                    iconColor: .red
                ) {
                    ChipGrid(
                        items: scene.makeup.map(\.name),
                        color: .red
                    )
                }
            }

            // MARK: Equipment

            if !scene.equipment.isEmpty {
                SectionCard(
                    title: "Equipment",
                    icon: "camera.fill",
                    iconColor: .yellow
                ) {
                    ForEach(scene.equipment) { item in
                        EntityDetailRow(
                            name: item.name,
                            detail: item.department,
                            icon: "camera.fill",
                            iconColor: .yellow,
                            sceneCount: sceneCount(
                                entityId: item.id,
                                in: breakdown.scenes,
                                matching: {
                                    $0.equipment.contains { $0.id == item.id }
                                }
                            )
                        )
                    }
                }
            }

            // MARK: Post Production

            if !scene.vfx.isEmpty ||
                !scene.sfx.isEmpty ||
                !scene.sound.isEmpty ||
                !scene.music.isEmpty {

                SectionCard(
                    title: "Post Production",
                    icon: "sparkles",
                    iconColor: .purple
                ) {

                    if !scene.vfx.isEmpty {
                        PostChipGroup(
                            label: "",
                            items: scene.vfx,
                            color: .indigo
                        )
                    }

                    if !scene.sfx.isEmpty {
                        PostChipGroup(
                            label: "",
                            items: scene.sfx,
                            color: .purple
                        )
                    }

                    if !scene.sound.isEmpty {
                        PostChipGroup(
                            label: "",
                            items: scene.sound,
                            color: .blue
                        )
                    }

                    if !scene.music.isEmpty {
                        PostChipGroup(
                            label: "",
                            items: scene.music,
                            color: .pink
                        )
                    }
                }
            }
        }
    }
    // MARK: - Scene count helper

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
                        .foregroundStyle(iconColor)
                }
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.white)
                Spacer()
            }
            content
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassEffect(in: RoundedRectangle(cornerRadius: 24))
    }
}

// MARK: - Entity Detail Row (Characters, Locations, Vehicles…)

struct EntityDetailRow: View {

    let name:       String
    let detail:     String
    let icon:       String
    let iconColor:  Color
    let sceneCount: Int

    var body: some View {
        HStack(spacing: 10) {

            // Left: icon + scene badge
          //  VStack(spacing: 4) {
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.12))
                        .frame(width: 28, height: 28)
                    Image(systemName: icon)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(iconColor)
                }
       //     }

            // Right: name + detail
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
     //   .background(Color.white.opacity(0.04))
        .glassEffect(in: RoundedRectangle(cornerRadius: 24))
        //.clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

// MARK: - Chip Grid (Props, Wardrobe, etc.)

struct ChipGrid: View {

    let items: [String]
    var color: Color = .white

    var body: some View {
        // Wrapping chip layout using flexible grid
        LazyVGrid(
            columns: [GridItem(.adaptive(minimum:64), spacing: 4)],
            alignment: .leading,
           // spacing: 8
        ) {
            ForEach(items, id: \.self) { item in
                Text(item)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(color)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .minimumScaleFactor(0.01)  // Allows text to shrink as much as needed
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
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
               // .font(.caption)
             //   .fontWeight(.semibold)
                .foregroundStyle(color.opacity(0.7))
            ChipGrid(items: items, color: color)
        }
    }
}
