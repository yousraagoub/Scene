//
//  APIClient.swift
//  Scene
//
//  Created by Yousra Abdelrahman on 19/11/1447 AH.
//

import Foundation
//import OpenAI

//  Production Entity Models
struct ChatResponse: Codable {
    struct Choice: Codable {
        struct Message: Codable {
            let content: String
        }
        let message: Message
    }
    let choices: [Choice]
}

struct ProductionEntities: Codable {
    let characters: [Character]
    let props: [Prop]
    let wardrobe: [WardrobeItem]
    let makeup: [MakeupItem]
    let locations: [Location]
    let vehicles: [Vehicle]
    let animals: [Animal]
    let vfxAssets: [VFXAsset]
    let sfxAssets: [SFXAsset]
    let equipment: [Equipment]
}

struct Character: Codable, Identifiable {
    let characterId: String
    let canonicalName: String
    let aliases: [String]
    let defaultTraits: CharacterTraits

    var id: String { characterId }
}

struct CharacterTraits: Codable {
    let wardrobe: [String]
    let makeup: [String]
}

struct Prop: Codable, Identifiable {
    let propId: String
    let name: String
    let category: String

    var id: String { propId }
}

struct WardrobeItem: Codable, Identifiable {
    let wardrobeId: String
    let name: String

    var id: String { wardrobeId }
}

struct MakeupItem: Codable, Identifiable {
    let makeupId: String
    let name: String

    var id: String { makeupId }
}

struct Location: Codable, Identifiable {
    let locationId: String
    let name: String
    let type: String
    let parentLocationId: String

    var id: String { locationId }
}

struct Vehicle: Codable, Identifiable {
    let vehicleId: String
    let name: String
    let type: String

    var id: String { vehicleId }
}

struct Animal: Codable, Identifiable {
    let animalId: String
    let name: String

    var id: String { animalId }
}

struct VFXAsset: Codable, Identifiable {
    let vfxId: String
    let name: String

    var id: String { vfxId }
}

struct SFXAsset: Codable, Identifiable {
    let sfxId: String
    let name: String

    var id: String { sfxId }
}

struct Equipment: Codable, Identifiable {
    let equipmentId: String
    let name: String
    let department: String

    var id: String { equipmentId }
}

//  Scene Models

struct Scene: Codable, Identifiable {
    let sceneId: String
    let heading: String
    let locationId: String
    let time: String
    let sceneLayers: SceneLayers

    var id: String { sceneId }
}

struct SceneLayers: Codable {
    let performance: PerformanceLayer
    let production: ProductionLayer
    let post: PostLayer
}

struct PerformanceLayer: Codable {
    let cast: [CastMember]
    let extras: [Extra]
    let animals: [String]
}

struct CastMember: Codable {
    let characterId: String
    let relations: [Relation]
    let stunt: [String]
    let state: [String]
}

struct Relation: Codable {
    let type: String
    let targetId: String
}

struct Extra: Codable {
    let type: String
    let count: Int
    let wardrobeDescription: String
    let relations: [String]
}

struct ProductionLayer: Codable {
    let props: [String]
    let vehicles: [String]
    let setDressing: [String]
    let wardrobe: [String]
    let makeup: [String]
    let equipment: [String]
}

struct PostLayer: Codable {
    let vfx: [String]
    let sfx: [String]
    let sound: [String]
    let music: [String]
}

// Root Response Model

struct ScreenplayBreakdown: Codable {
    let productionEntities: ProductionEntities
    let scenes: [Scene]
}

// Analyzer Errors

enum ScreenplayAnalyzerError: LocalizedError {
    case noContent
    case invalidJSON(String)
    case apiError(String)

    var errorDescription: String? {
        switch self {
        case .noContent:
            return "The API returned an empty response."
        case .invalidJSON(let detail):
            return "Failed to parse JSON: \(detail)"
        case .apiError(let detail):
            return "API error: \(detail)"
        }
    }
}
