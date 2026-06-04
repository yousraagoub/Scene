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

                    Picker(
                        "",
                        selection: $showBudget
                    ) {

                        Text("Breakdown")
                            .tag(false)

                        Text("Budget")
                            .tag(true)
                    }
                    .pickerStyle(.segmented)
                    .tint(.white)
                    .padding(.bottom, 10)
//                    .frame(width: 240)

                    Spacer()

                    if !showBudget {

                        SceneNavigationView(
                            sceneIndex: $selectedSceneIndex,
                            totalScenes: breakdown.scenes.count
                        )
                    }
                }

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

                    visualEffectsSection(
                        scene: scene
                    )
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
                title: "Characters",
                count: scene.characters.count,
                icon: "person.3.fill"
            )

            SummaryCard(
                title: "Locations",
                count: scene.locations.count,
                icon: "mappin.and.ellipse"
            )

            SummaryCard(
                title: "Props",
                count: scene.props.count,
                icon: "shippingbox.fill"
            )
        }
    }

    @ViewBuilder
    func charactersSection(
        scene: SceneBreakdown
    ) -> some View {

        BreakdownSectionCard(
            title: "Characters",
            icon: "person.3.fill"
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
            icon: "mappin.and.ellipse"
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
            icon: "shippingbox.fill"
        ) {

            ForEach(scene.props) {
                PropRow(prop: $0)
            }
        }
    }

    @ViewBuilder
    func visualEffectsSection(
        scene: SceneBreakdown
    ) -> some View {

        BreakdownSectionCard(
            title: "Visual Effects",
            icon: "sparkles"
        ) {

            ForEach(
                scene.visualEffects,
                id: \.self
            ) { effect in

                Text(effect)
                    .padding()
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                    .background(
                        Color.white.opacity(0.04)
                    )
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 16
                        )
                    )
            }
        }
    }
}
