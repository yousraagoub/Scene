//
//  BudgetView.swift
//  Scene
//
import SwiftUI

struct BudgetView: View {

    let breakdown: ScriptBreakdown

    @State private var values: [String:String] = [:]

    private var total: Double {

        values.values.reduce(0) {
            $0 + (Double($1) ?? 0)
        }
    }

    private var totalItems: Int {

        breakdown.totalCharacters.count
        + breakdown.totalLocations.count
        + breakdown.totalProps.count
    }

    private var completedItems: Int {

        values.values.filter {
            !(($0.trimmingCharacters(in: .whitespaces)).isEmpty)
        }.count
    }

    var body: some View {

        HStack(alignment: .top, spacing: 32) {

            ScrollView {

                VStack(spacing: 16) {

                    HStack {
                        Text("Production Budget")
                            .font(.title)
                            .foregroundStyle(.white)

                        Spacer()
                    }

                    ForEach(
                        breakdown.totalCharacters
                    ) { character in

                        BudgetRow(
                            title: character.name,
                            icon: "person.2.fill",
                            color: Color.characterCard,
                            value: Binding(
                                get: {
                                    values[character.name] ?? ""
                                },
                                set: {
                                    values[character.name] = $0
                                }
                            )
                        )
                    }

                    Divider()

                    ForEach(
                        breakdown.totalLocations
                    ) { location in

                        BudgetRow(
                            title: location.name,
                            icon: "mappin.and.ellipse",
                            color: Color.locatioinCard,
                            value: Binding(
                                get: {
                                    values[location.name] ?? ""
                                },
                                set: {
                                    values[location.name] = $0
                                }
                            )
                        )
                    }

                    Divider()

                    ForEach(
                        breakdown.totalProps
                    ) { prop in

                        BudgetRow(
                            title: prop.name,
                            icon: "shippingbox.fill",
                            color: Color.propsCard,
                            value: Binding(
                                get: {
                                    values[prop.name] ?? ""
                                },
                                set: {
                                    values[prop.name] = $0
                                }
                            )
                        )
                    }
                }
            }

            BudgetProgressView(
                completedItems: completedItems,
                totalItems: totalItems,
                totalBudget: total
            )
//            .frame(width: 280)
//            .frame(height: 480, alignment: .topLeading)
            .fixedSize(horizontal: true, vertical: true)
        }
    }
}
