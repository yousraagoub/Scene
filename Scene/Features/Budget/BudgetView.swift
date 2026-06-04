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

    var body: some View {

        ScrollView {

            VStack(spacing: 16) {

                ForEach(
                    breakdown.totalCharacters
                ) { character in

                    BudgetRow(
                        title: character.name,
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

                ForEach(
                    breakdown.totalLocations
                ) { location in

                    BudgetRow(
                        title: location.name,
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

                ForEach(
                    breakdown.totalProps
                ) { prop in

                    BudgetRow(
                        title: prop.name,
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

                Divider()

                HStack {

                    Text("Total Budget")

                    Spacer()

                    Text("$\(total)")
                        .bold()
                }
                .padding()
            }
        }
    }
}

