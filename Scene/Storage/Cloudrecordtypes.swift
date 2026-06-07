//
//  Cloudrecordtypes.swift
//  Scene
//
//  Created by Raghad Alzemami on 21/12/1447 AH.
//

import Foundation

// MARK: - Record Types (3 total)

enum CloudRecordType {
    static let projects  = "Projects"
    static let entities  = "Entities"
    static let scenes    = "Scenes"
}

// MARK: - Projects fields

enum ProjectField {
    static let title      = "title"
    static let genre      = "genre"
    static let scriptType = "scriptType"
    static let status     = "status"
    static let createdAt  = "createdAt"
}

// MARK: - Entities fields

enum EntityField {
    static let projectRef  = "projectRef"
    static let entityId    = "entityId"     // AI's stable ID e.g. "char_001"
    static let entityType  = "entityType"   // one of EntityType constants below
    static let name        = "name"
    static let subtype     = "subtype"      // category | type | department depending on entityType
    static let aliases     = "aliases"      // [String] — characters only
    static let cost        = "cost"         // Double, default 0
}

// MARK: - Scenes fields

enum SceneField {
    static let projectRef    = "projectRef"
    static let sceneId       = "sceneId"
    static let number        = "number"
    static let heading       = "heading"
    static let time          = "time"
    static let locationId    = "locationId"     // single entity ID — one location per scene
    static let characterIds  = "characterIds"   // [String] entity IDs
    static let characterData = "characterData"  // JSON String [{id, state, stunts}]
    static let propIds       = "propIds"
    static let vehicleIds    = "vehicleIds"
    static let animalIds     = "animalIds"
    static let wardrobeIds   = "wardrobeIds"
    static let makeupIds     = "makeupIds"
    static let equipmentIds  = "equipmentIds"
    static let setDressing   = "setDressing"    // [String] raw names — not entity IDs
    static let vfxNames      = "vfxNames"       // [String] resolved names
    static let sfxNames      = "sfxNames"
    static let sound         = "sound"
    static let music         = "music"
}

// MARK: - Entity type values

enum EntityType {
    static let character = "character"
    static let location  = "location"
    static let prop      = "prop"
    static let vehicle   = "vehicle"
    static let animal    = "animal"
    static let wardrobe  = "wardrobe"
    static let makeup    = "makeup"
    static let equipment = "equipment"
}

// MARK: - CloudKit console setup
//
// Required queryable indexes:
//   Entities  → projectRef (queryable)
//   Scenes    → projectRef (queryable)
//
// Deletion cascade:
//   Delete Projects record → CloudKit auto-deletes all Entities and Scenes
//   via their .deleteSelf projectRef references.
