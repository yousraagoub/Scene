//
//  BreakdownModels.swift
//  Scene
//
import Foundation

struct ScriptBreakdown {

    var sceneCount: Int

    var characters: [CharacterBreakdown]

    var locations: [LocationBreakdown]

    var props: [PropBreakdown]

    var visualEffects: [String]
}

struct CharacterBreakdown: Identifiable {

    let id = UUID()

    let name: String

    let role: String

    let sceneCount: Int
}

struct LocationBreakdown: Identifiable {

    let id = UUID()

    let name: String

    let type: String

    let sceneCount: Int
}

struct PropBreakdown: Identifiable {

    let id = UUID()

    let name: String
}
