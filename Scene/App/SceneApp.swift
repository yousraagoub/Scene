//
//  SceneApp.swift
//  Scene
//
import SwiftUI
import SwiftData
//import OpenAI
//import OpenAI

@main
struct SceneApp: App {

    @StateObject private var settings  = AppSettings()
    @StateObject private var appState  = AppState()
    @StateObject private var authService = CloudAuthService()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false, cloudKitDatabase: .none)
        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some SwiftUI.Scene {
        WindowGroup {
            SceneRootView()
                .environmentObject(appState)
                .environmentObject(settings)
                .environmentObject(authService)
                .environment(\.locale, settings.locale)
                .environment(\.layoutDirection, settings.layoutDirection)
                .id(settings.language)
                .task {
                    await appState.start(authService: authService)
                }
        }
        .defaultSize(width: 1400, height: 900)
        .windowResizability(.automatic)
        .modelContainer(sharedModelContainer)
    }
}

