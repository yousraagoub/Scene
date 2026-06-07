//
//  ProjectDetailView.swift
//  Scene
//
//  Created by Raghad Alzemami on 21/12/1447 AH.
//

import SwiftUI

struct ProjectDetailView: View {

    @State var vm: ProjectViewModel

    init(project: ProjectModel) {
        _vm = State(initialValue: ProjectViewModel(project: project))
    }

    var body: some View {
        Group {
            if vm.isLoading {
                ProgressView("Loading breakdown…")

            } else if vm.breakdown != nil {
                BreakdownView(
                    breakdown: Binding(
                        get: { vm.breakdown! },
                        set: { vm.breakdown = $0 }
                    ),
                    // Fix 1: wire cost changes to CloudKit via vm.updateCost
                    onCostChange: { entityId, cost in
                        vm.updateCost(cost, entityId: entityId)
                    }
                )

            } else if vm.error != nil {
                ContentUnavailableView(
                    "Failed to Load",
                    systemImage: "exclamationmark.triangle",
                    description: Text("Check your connection and try again.")
                )

            } else {
                ContentUnavailableView(
                    "No Breakdown",
                    systemImage: "film",
                    description: Text("Upload a screenplay to generate a breakdown.")
                )
            }
        }
        .navigationTitle(vm.project.title)
        .task {
            await vm.loadBreakdown()
        }
    }
}
