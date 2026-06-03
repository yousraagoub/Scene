//
//  SceneProject.swift
//  Scene
//

import Foundation

struct ProjectModel: Identifiable {

    let id = UUID()

    var title: String

    var genre: String

    var scriptType: ScriptType

    var fileURL: URL?

    var breakdown: ScriptBreakdown?
}

enum ScriptType: String, CaseIterable {

    case film = "Film"
    case series = "Series"
}
