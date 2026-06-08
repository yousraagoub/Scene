import SwiftUI

struct BreakdownView: View {

    let project: ProjectModel

    @State private var selectedSceneIndex = 0

    @State private var showBudget = false

    var body: some View {

        if let breakdown = project.breakdown {

            VStack{

                // MARK: - Top Bar

                HStack {

                    HStack(spacing: 0) {

                        Button {
                            withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
                                showBudget = false
                            }
                        } label: {
                            Text("Breakdown")
                                .font(.title2)
                                .frame(width: 120)
                                .fixedSize(horizontal: true, vertical: true)
                        }
                        .buttonStyle(.plain)
                        .foregroundStyle(showBudget == false ? .black : .white)
                        .background(showBudget == false ? Color.white : Color.clear)

                        Button {
                            withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
                                showBudget = true
                            }
                        } label: {
                            Text("Budget")
                                .font(.title2)
                                .frame(width: 120)
                                .fixedSize(horizontal: true, vertical: true)
                        }
                        .buttonStyle(.plain)
                        .foregroundStyle(showBudget == true ? .black : .white)
                        .background(showBudget == true ? Color.white : Color.clear)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .glassEffect( in: RoundedRectangle(cornerRadius: 8))
                    .padding()
                    
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 8)
//                            .stroke(.white.opacity(0.1))
//                    )
//                    .glassEffect( in: RoundedRectangle(cornerRadius: 8))

                    Spacer()

                    if !showBudget {
                        SceneNavigationView(
                            sceneIndex: $selectedSceneIndex,
                            totalScenes: breakdown.scenes.count
                        )
                    }
                }
                .padding(.bottom, 10)

                // MARK: - Content

                if showBudget {

                    BudgetView(
                        breakdown: breakdown
                    )

                } else {

                    breakdownContent(
                        breakdown: breakdown
                    )
                }
            }

        } else {

            ContentUnavailableView(
                "No Breakdown",
                systemImage: "film"
            )
        }
    }
}

// MARK: - Breakdown Content

extension BreakdownView {

    @ViewBuilder
    func breakdownContent(
        breakdown: ScriptBreakdown
    ) -> some View {

        let scene =
        breakdown.scenes[selectedSceneIndex]

        ScrollView {

            VStack(spacing: 24) {

                topCards(
                    scene: scene
                )

                HStack(alignment: .top) {

                    charactersSection(
                        scene: scene
                    )

                    locationsSection(
                        scene: scene
                    )
                }

                HStack(alignment: .top) {

                    propsSection(
                        scene: scene
                    )

//                    visualEffectsSection(
//                        scene: scene
//                    )
                }
            }
        }
    }
}

// MARK: - Sections

extension BreakdownView {

    @ViewBuilder
    func topCards(
        scene: SceneBreakdown
    ) -> some View {

        HStack(spacing: 20) {
            SummaryCard(
                title: "Total Scenes",
                count: project.breakdown!.scenes.count,
                icon: "film.stack.fill",
                color: .sceneCard
            )
            SummaryCard(
                title: "Total Characters",
                count: project.breakdown!.totalCharacters.count,
                icon: "person.2.fill",
                color: .characterCard
            )

            SummaryCard(
                title: "Total Locations",
                count: project.breakdown!.totalLocations.count,
                icon: "mappin.and.ellipse",
                color: .locatioinCard
            )
        }
    }

    @ViewBuilder
    func charactersSection(
        scene: SceneBreakdown
    ) -> some View {

        BreakdownSectionCard(
            title: "Characters",
            icon: "person.2.fill",
            color: Color.characterCard
        ) {

            ForEach(scene.characters) {
                CharacterRow(character: $0)
            }
        }
    }

    @ViewBuilder
    func locationsSection(
        scene: SceneBreakdown
    ) -> some View {

        BreakdownSectionCard(
            title: "Locations",
            icon: "mappin.and.ellipse",
            color: Color.locatioinCard
        ) {

            ForEach(scene.locations) {
                LocationRow(location: $0)
            }
        }
    }

    @ViewBuilder
    func propsSection(
        scene: SceneBreakdown
    ) -> some View {

        BreakdownSectionCard(
            title: "Props",
            icon: "shippingbox.fill",
            color: Color.propsCard
        ) {

            ForEach(scene.props) {
                PropRow(prop: $0)
            }
        }
    }

//    @ViewBuilder
//    func visualEffectsSection(
//        scene: SceneBreakdown
//    ) -> some View {
//
//        BreakdownSectionCard(
//            title: "Visual Effects",
//            icon: "sparkles",
//            color: Color.vfxCard
//        ) {
//
//            ForEach(
//                scene.visualEffects,
//                id: \.self
//            ) { effect in
//
//                Text(effect)
//                    .padding()
//                    .frame(
//                        maxWidth: .infinity,
//                        alignment: .leading
//                    )
//                    .background(
//                        Color.white.opacity(0.04)
//                    )
//                    .clipShape(
//                        RoundedRectangle(
//                            cornerRadius: 16
//                        )
//                    )
//            }
//        }
//    }
}
