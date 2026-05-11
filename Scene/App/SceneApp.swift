//
//  SceneApp.swift
//  Scene
//
//  Created by Yousra Abdelrahman on 19/11/1447 AH.
//

import SwiftUI
import SwiftData

@main
struct SceneApp: App {
    
    @StateObject private var settings = AppSettings()
    @StateObject private var appState = AppState()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            SceneRootView()
                .environmentObject(appState)
                .environmentObject(settings)
                .environment(\.locale, settings.locale)
                .environment(\.layoutDirection, settings.layoutDirection)
                .id(settings.language) 
        }
        .defaultSize(width: 1400, height: 900)
        .windowResizability(.contentSize)
        .modelContainer(sharedModelContainer)
    }
}
