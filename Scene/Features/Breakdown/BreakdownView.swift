//
//  BreakdownView.swift
//  Scene
//
import SwiftUI

struct BreakdownView: View {

    let project: ProjectModel

    var body: some View {

        ScrollView {

            if let breakdown = project.breakdown {

                VStack(spacing: 24) {

                    topCards(
                        breakdown: breakdown
                    )

                    HStack(alignment: .top, spacing: 24) {

                        charactersSection(
                            breakdown: breakdown
                        )

                        locationsSection(
                            breakdown: breakdown
                        )
                    }

                    HStack(alignment: .top, spacing: 24) {

                        propsSection(
                            breakdown: breakdown
                        )

                        visualEffectsSection(
                            breakdown: breakdown
                        )
                    }
                }
                .padding()
            }
            else {

                ContentUnavailableView(
                    "No Breakdown Available",
                    systemImage: "movieclapper",
                    description: Text(
                        "Upload and analyze a script first."
                    )
                )
            }
        }
    }
}


extension BreakdownView {

    @ViewBuilder
    func topCards(
        breakdown: ScriptBreakdown
    ) -> some View {

        HStack(spacing: 20) {

            SummaryCard(
                title: "Scenes",
                count: breakdown.sceneCount,
                icon: "movieclapper"
            )

            SummaryCard(
                title: "Characters",
                count: breakdown.characters.count,
                icon: "person.3.fill"
            )

            SummaryCard(
                title: "Locations",
                count: breakdown.locations.count,
                icon: "mappin.and.ellipse"
            )
        }
    }

    @ViewBuilder
    func charactersSection(
        breakdown: ScriptBreakdown
    ) -> some View {

        BreakdownSectionCard(
            title: "Characters",
            icon: "person.3.fill"
        ) {

            ForEach(breakdown.characters) {
                CharacterRow(character: $0)
            }
        }
    }

    @ViewBuilder
    func locationsSection(
        breakdown: ScriptBreakdown
    ) -> some View {

        BreakdownSectionCard(
            title: "Locations",
            icon: "mappin.and.ellipse"
        ) {

            ForEach(breakdown.locations) {
                LocationRow(location: $0)
            }
        }
    }

    @ViewBuilder
    func propsSection(
        breakdown: ScriptBreakdown
    ) -> some View {

        BreakdownSectionCard(
            title: "Props",
            icon: "shippingbox.fill"
        ) {

            ForEach(breakdown.props) {
                PropRow(prop: $0)
            }
        }
    }

    @ViewBuilder
    func visualEffectsSection(
        breakdown: ScriptBreakdown
    ) -> some View {

        BreakdownSectionCard(
            title: "Visual Effects",
            icon: "sparkles"
        ) {

            ForEach(
                breakdown.visualEffects,
                id: \.self
            ) { effect in

                Text(effect)
                    .padding()
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                    .background(
                        Color.white.opacity(0.04)
                    )
                    .clipShape(
                        RoundedRectangle(cornerRadius: 16)
                    )
            }
        }
    }
}
