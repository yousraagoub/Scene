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
    
    @StateObject private var settings = AppSettings()
    @StateObject private var appState = AppState()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Itemm.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

 

    var body: some SwiftUI.Scene {

        WindowGroup {
            
            SceneRootView()
                .environmentObject(appState)
                .environmentObject(settings)
                .environment(\.locale, settings.locale)
                .environment(\.layoutDirection, settings.layoutDirection)
                .id(settings.language)
                .onAppear {
                    appState.start()
                }
        }
        .defaultSize(width: 1400, height: 900)
        .windowResizability(.automatic)
        .modelContainer(sharedModelContainer)
    }
}
