//
//  ProjectDetailView.swift
//  Scene
//

import SwiftUI

struct ProjectDetailView: View {
    @State var vm: ProjectViewModel
    @EnvironmentObject var settings: AppSettings
    
    init(project: ProjectModel) {
        _vm = State(initialValue: ProjectViewModel(project: project))
    }

    var body: some View {
        Group {
            if vm.isLoading {
                ProgressView(settings.language == .arabic ? "تحميل التفاصيل..." : "Loading breakdown…")

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
                    settings.language == .arabic ? "فشل في تحميل" : "Failed to Load",
                    systemImage: "exclamationmark.triangle",
                    description: Text(settings.language == .arabic ? "تأكد من اتصالك بالإنترنت وحاول مرة أخرى." : "Check your connection and try again.")
                )

            } else {
                ContentUnavailableView(
                    settings.language == .arabic ? "لا يوجد تفاصيل" : "No Breakdown",
                    systemImage: "film",
                    description: Text(settings.language == .arabic ? "إرفاق السيناريو لإنشاء تفاصيل." : "Upload a screenplay to generate a breakdown.")
                )
            }
        }
        .navigationTitle(vm.project.title)
        .task {
            await vm.loadBreakdown()
        }
    }
}
