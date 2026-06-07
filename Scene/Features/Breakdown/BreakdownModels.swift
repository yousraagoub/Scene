import CloudKit
import Foundation

// MARK: - ScriptBreakdown

struct ScriptBreakdown {

    var scenes:          [SceneBreakdown]
    var totalCharacters: [CharacterBreakdown]
    var totalLocations:  [LocationBreakdown]
    var totalProps:      [PropBreakdown]
    var totalVehicles:   [VehicleBreakdown]
    var totalAnimals:    [AnimalBreakdown]
    var totalWardrobe:   [WardrobeBreakdown]
    var totalMakeup:     [MakeupBreakdown]
    var totalEquipment:  [EquipmentBreakdown]
    var totalVFX:        [String]
    var totalSFX:        [String]

    var totalBudget: Double {
        [
            totalCharacters.map(\.cost),
            totalLocations.map(\.cost),
            totalProps.map(\.cost),
            totalVehicles.map(\.cost),
            totalAnimals.map(\.cost),
            totalWardrobe.map(\.cost),
            totalMakeup.map(\.cost),
            totalEquipment.map(\.cost)
        ]
        .flatMap { $0 }
        .reduce(0, +)
    }
}

// MARK: - SceneBreakdown

struct SceneBreakdown: Identifiable {

    let id:      String     // AI's sceneId — stable, used as CloudKit recordName suffix
    let number:  Int
    let heading: String
    let time:    String

    let characters:  [CharacterBreakdown]
    let locations:   [LocationBreakdown]
    let props:       [PropBreakdown]
    let vehicles:    [VehicleBreakdown]
    let animals:     [AnimalBreakdown]
    let wardrobe:    [WardrobeBreakdown]
    let makeup:      [MakeupBreakdown]
    let equipment:   [EquipmentBreakdown]
    let setDressing: [String]
    let vfx:         [String]
    let sfx:         [String]
    let sound:       [String]
    let music:       [String]
}

// MARK: - Entity types
//
// id      = AI's stable entity ID → CloudKit recordName suffix
// cost    = 0 by default; edited once per entity for the whole production
// stateInScene / stuntsInScene = only meaningful inside a SceneBreakdown;
//           empty on totalCharacters entries

struct CharacterBreakdown: Identifiable {
    let id:      String
    let name:    String
    let aliases: [String]
    var cost:    Double = 0
    var stateInScene:  [String] = []
    var stuntsInScene: [String] = []
}

struct LocationBreakdown: Identifiable {
    let id:   String
    let name: String
    let type: String
    var cost: Double = 0
}

struct PropBreakdown: Identifiable {
    let id:       String
    let name:     String
    let category: String
    var cost:     Double = 0
}

struct VehicleBreakdown: Identifiable {
    let id:   String
    let name: String
    let type: String
    var cost: Double = 0
}

struct AnimalBreakdown: Identifiable {
    let id:   String
    let name: String
    var cost: Double = 0
}

struct WardrobeBreakdown: Identifiable {
    let id:   String
    let name: String
    var cost: Double = 0
}

struct MakeupBreakdown: Identifiable {
    let id:   String
    let name: String
    var cost: Double = 0
}

struct EquipmentBreakdown: Identifiable {
    let id:         String
    let name:       String
    let department: String
    var cost:       Double = 0
}

// MARK: - EntityMap
//
// A typed lookup built from the Entities CKRecords fetched for a project.
// Keys = AI entityId (e.g. "char_001"). Used by SceneBreakdown to resolve
// its stored ID arrays into fully-typed model objects.

struct EntityMap {
    var characters: [String: CharacterBreakdown] = [:]
    var locations:  [String: LocationBreakdown]  = [:]
    var props:      [String: PropBreakdown]      = [:]
    var vehicles:   [String: VehicleBreakdown]   = [:]
    var animals:    [String: AnimalBreakdown]     = [:]
    var wardrobe:   [String: WardrobeBreakdown]  = [:]
    var makeup:     [String: MakeupBreakdown]    = [:]
    var equipment:  [String: EquipmentBreakdown] = [:]

    var allCharacters: [CharacterBreakdown] { Array(characters.values).sorted { $0.name < $1.name } }
    var allLocations:  [LocationBreakdown]  { Array(locations.values).sorted  { $0.name < $1.name } }
    var allProps:      [PropBreakdown]      { Array(props.values).sorted      { $0.name < $1.name } }
    var allVehicles:   [VehicleBreakdown]   { Array(vehicles.values).sorted   { $0.name < $1.name } }
    var allAnimals:    [AnimalBreakdown]    { Array(animals.values).sorted    { $0.name < $1.name } }
    var allWardrobe:   [WardrobeBreakdown]  { Array(wardrobe.values).sorted   { $0.name < $1.name } }
    var allMakeup:     [MakeupBreakdown]    { Array(makeup.values).sorted     { $0.name < $1.name } }
    var allEquipment:  [EquipmentBreakdown] { Array(equipment.values).sorted  { $0.name < $1.name } }
}

// MARK: - CharacterSceneEntry (private serialisation helper)
//
// Encodes per-scene character metadata (state, stunts) as JSON
// stored on the Scenes CloudKit record.

struct CharacterSceneEntry: Codable {
    let id:     String
    let state:  [String]
    let stunts: [String]
}

// MARK: - CloudKit: Entity models ↔ CKRecord

extension CharacterBreakdown {

    init?(ckRecord: CKRecord) {
        guard let name = ckRecord[EntityField.name] as? String,
              let entityId = ckRecord[EntityField.entityId] as? String
        else { return nil }
        self.id      = entityId
        self.name    = name
        self.aliases = ckRecord[EntityField.aliases] as? [String] ?? []
        self.cost    = ckRecord[EntityField.cost]    as? Double   ?? 0
    }

    func toCKRecord(projectId: String, projectRef: CKRecord.Reference) -> CKRecord {
        let r = CKRecord(recordType: CloudRecordType.entities,
                         recordID: CKRecord.ID(recordName: "\(projectId)_\(id)"))
        r[EntityField.projectRef] = projectRef
        r[EntityField.entityId]   = id
        r[EntityField.entityType] = EntityType.character
        r[EntityField.name]       = name
        r[EntityField.aliases]    = aliases.isEmpty ? nil : aliases
        r[EntityField.cost]       = cost
        return r
    }
}

extension LocationBreakdown {

    init?(ckRecord: CKRecord) {
        guard let name = ckRecord[EntityField.name] as? String,
              let entityId = ckRecord[EntityField.entityId] as? String
        else { return nil }
        self.id   = entityId
        self.name = name
        self.type = ckRecord[EntityField.subtype] as? String ?? ""
        self.cost = ckRecord[EntityField.cost]    as? Double ?? 0
    }

    func toCKRecord(projectId: String, projectRef: CKRecord.Reference) -> CKRecord {
        let r = CKRecord(recordType: CloudRecordType.entities,
                         recordID: CKRecord.ID(recordName: "\(projectId)_\(id)"))
        r[EntityField.projectRef] = projectRef
        r[EntityField.entityId]   = id
        r[EntityField.entityType] = EntityType.location
        r[EntityField.name]       = name
        r[EntityField.subtype]    = type
        r[EntityField.cost]       = cost
        return r
    }
}

extension PropBreakdown {

    init?(ckRecord: CKRecord) {
        guard let name = ckRecord[EntityField.name] as? String,
              let entityId = ckRecord[EntityField.entityId] as? String
        else { return nil }
        self.id       = entityId
        self.name     = name
        self.category = ckRecord[EntityField.subtype] as? String ?? "unknown"
        self.cost     = ckRecord[EntityField.cost]    as? Double ?? 0
    }

    func toCKRecord(projectId: String, projectRef: CKRecord.Reference) -> CKRecord {
        let r = CKRecord(recordType: CloudRecordType.entities,
                         recordID: CKRecord.ID(recordName: "\(projectId)_\(id)"))
        r[EntityField.projectRef] = projectRef
        r[EntityField.entityId]   = id
        r[EntityField.entityType] = EntityType.prop
        r[EntityField.name]       = name
        r[EntityField.subtype]    = category
        r[EntityField.cost]       = cost
        return r
    }
}

extension VehicleBreakdown {

    init?(ckRecord: CKRecord) {
        guard let name = ckRecord[EntityField.name] as? String,
              let entityId = ckRecord[EntityField.entityId] as? String
        else { return nil }
        self.id   = entityId
        self.name = name
        self.type = ckRecord[EntityField.subtype] as? String ?? ""
        self.cost = ckRecord[EntityField.cost]    as? Double ?? 0
    }

    func toCKRecord(projectId: String, projectRef: CKRecord.Reference) -> CKRecord {
        let r = CKRecord(recordType: CloudRecordType.entities,
                         recordID: CKRecord.ID(recordName: "\(projectId)_\(id)"))
        r[EntityField.projectRef] = projectRef
        r[EntityField.entityId]   = id
        r[EntityField.entityType] = EntityType.vehicle
        r[EntityField.name]       = name
        r[EntityField.subtype]    = type
        r[EntityField.cost]       = cost
        return r
    }
}

extension AnimalBreakdown {

    init?(ckRecord: CKRecord) {
        guard let name = ckRecord[EntityField.name] as? String,
              let entityId = ckRecord[EntityField.entityId] as? String
        else { return nil }
        self.id   = entityId
        self.name = name
        self.cost = ckRecord[EntityField.cost] as? Double ?? 0
    }

    func toCKRecord(projectId: String, projectRef: CKRecord.Reference) -> CKRecord {
        let r = CKRecord(recordType: CloudRecordType.entities,
                         recordID: CKRecord.ID(recordName: "\(projectId)_\(id)"))
        r[EntityField.projectRef] = projectRef
        r[EntityField.entityId]   = id
        r[EntityField.entityType] = EntityType.animal
        r[EntityField.name]       = name
        r[EntityField.cost]       = cost
        return r
    }
}

extension WardrobeBreakdown {

    init?(ckRecord: CKRecord) {
        guard let name = ckRecord[EntityField.name] as? String,
              let entityId = ckRecord[EntityField.entityId] as? String
        else { return nil }
        self.id   = entityId
        self.name = name
        self.cost = ckRecord[EntityField.cost] as? Double ?? 0
    }

    func toCKRecord(projectId: String, projectRef: CKRecord.Reference) -> CKRecord {
        let r = CKRecord(recordType: CloudRecordType.entities,
                         recordID: CKRecord.ID(recordName: "\(projectId)_\(id)"))
        r[EntityField.projectRef] = projectRef
        r[EntityField.entityId]   = id
        r[EntityField.entityType] = EntityType.wardrobe
        r[EntityField.name]       = name
        r[EntityField.cost]       = cost
        return r
    }
}

extension MakeupBreakdown {

    init?(ckRecord: CKRecord) {
        guard let name = ckRecord[EntityField.name] as? String,
              let entityId = ckRecord[EntityField.entityId] as? String
        else { return nil }
        self.id   = entityId
        self.name = name
        self.cost = ckRecord[EntityField.cost] as? Double ?? 0
    }

    func toCKRecord(projectId: String, projectRef: CKRecord.Reference) -> CKRecord {
        let r = CKRecord(recordType: CloudRecordType.entities,
                         recordID: CKRecord.ID(recordName: "\(projectId)_\(id)"))
        r[EntityField.projectRef] = projectRef
        r[EntityField.entityId]   = id
        r[EntityField.entityType] = EntityType.makeup
        r[EntityField.name]       = name
        r[EntityField.cost]       = cost
        return r
    }
}

extension EquipmentBreakdown {

    init?(ckRecord: CKRecord) {
        guard let name = ckRecord[EntityField.name] as? String,
              let entityId = ckRecord[EntityField.entityId] as? String
        else { return nil }
        self.id         = entityId
        self.name       = name
        self.department = ckRecord[EntityField.subtype] as? String ?? ""
        self.cost       = ckRecord[EntityField.cost]    as? Double ?? 0
    }

    func toCKRecord(projectId: String, projectRef: CKRecord.Reference) -> CKRecord {
        let r = CKRecord(recordType: CloudRecordType.entities,
                         recordID: CKRecord.ID(recordName: "\(projectId)_\(id)"))
        r[EntityField.projectRef] = projectRef
        r[EntityField.entityId]   = id
        r[EntityField.entityType] = EntityType.equipment
        r[EntityField.name]       = name
        r[EntityField.subtype]    = department
        r[EntityField.cost]       = cost
        return r
    }
}

// MARK: - CloudKit: SceneBreakdown ↔ CKRecord

extension SceneBreakdown {

    /// Rebuilds a SceneBreakdown from a Scenes CKRecord, resolving all
    /// entity ID arrays against the provided EntityMap.
    init?(ckRecord: CKRecord, entityMap: EntityMap) {
        guard
            let sceneId = ckRecord[SceneField.sceneId]  as? String,
            let number  = ckRecord[SceneField.number]   as? Int,
            let heading = ckRecord[SceneField.heading]  as? String,
            let time    = ckRecord[SceneField.time]     as? String
        else { return nil }

        self.id      = sceneId
        self.number  = number
        self.heading = heading
        self.time    = time

        // Decode per-scene character state/stunts from JSON
        var stateMap: [String: CharacterSceneEntry] = [:]
        if let json    = ckRecord[SceneField.characterData] as? String,
           let data    = json.data(using: .utf8),
           let entries = try? JSONDecoder().decode([CharacterSceneEntry].self, from: data) {
            stateMap = Dictionary(uniqueKeysWithValues: entries.map { ($0.id, $0) })
        }

        // Resolve character IDs → CharacterBreakdown, injecting scene state
        self.characters = (ckRecord[SceneField.characterIds] as? [String] ?? [])
            .compactMap { entityId -> CharacterBreakdown? in
                guard var c = entityMap.characters[entityId] else { return nil }
                if let entry = stateMap[entityId] {
                    c.stateInScene  = entry.state
                    c.stuntsInScene = entry.stunts
                }
                return c
            }

        // Resolve location
        self.locations = {
            guard let locationId = ckRecord[SceneField.locationId] as? String,
                  let l = entityMap.locations[locationId]
            else { return [] }
            return [l]
        }()

        // Resolve remaining entity ID arrays
        self.props     = (ckRecord[SceneField.propIds]      as? [String] ?? []).compactMap { entityMap.props[$0] }
        self.vehicles  = (ckRecord[SceneField.vehicleIds]   as? [String] ?? []).compactMap { entityMap.vehicles[$0] }
        self.animals   = (ckRecord[SceneField.animalIds]    as? [String] ?? []).compactMap { entityMap.animals[$0] }
        self.wardrobe  = (ckRecord[SceneField.wardrobeIds]  as? [String] ?? []).compactMap { entityMap.wardrobe[$0] }
        self.makeup    = (ckRecord[SceneField.makeupIds]    as? [String] ?? []).compactMap { entityMap.makeup[$0] }
        self.equipment = (ckRecord[SceneField.equipmentIds] as? [String] ?? []).compactMap { entityMap.equipment[$0] }

        // Raw string arrays — stored directly on the record
        self.setDressing = ckRecord[SceneField.setDressing] as? [String] ?? []
        self.vfx         = ckRecord[SceneField.vfxNames]    as? [String] ?? []
        self.sfx         = ckRecord[SceneField.sfxNames]    as? [String] ?? []
        self.sound       = ckRecord[SceneField.sound]        as? [String] ?? []
        self.music       = ckRecord[SceneField.music]        as? [String] ?? []
    }

    func toCKRecord(projectId: String) -> CKRecord {
        let r = CKRecord(recordType: CloudRecordType.scenes,
                         recordID: CKRecord.ID(recordName: "\(projectId)_\(id)"))

        r[SceneField.projectRef]  = CKRecord.Reference(
            recordID: CKRecord.ID(recordName: projectId),
            action: .deleteSelf
        )
        r[SceneField.sceneId]     = id
        r[SceneField.number]      = number
        r[SceneField.heading]     = heading
        r[SceneField.time]        = time
        r[SceneField.locationId]  = locations.first?.id

        // Encode character state/stunts as a JSON string
        let entries = characters.map {
            CharacterSceneEntry(id: $0.id, state: $0.stateInScene, stunts: $0.stuntsInScene)
        }
        if let data = try? JSONEncoder().encode(entries),
           let json = String(data: data, encoding: .utf8) {
            r[SceneField.characterData] = json
        }

        r[SceneField.characterIds]  = characters.map(\.id)
        r[SceneField.propIds]       = props.map(\.id)
        r[SceneField.vehicleIds]    = vehicles.map(\.id)
        r[SceneField.animalIds]     = animals.map(\.id)
        r[SceneField.wardrobeIds]   = wardrobe.map(\.id)
        r[SceneField.makeupIds]     = makeup.map(\.id)
        r[SceneField.equipmentIds]  = equipment.map(\.id)
        r[SceneField.setDressing]   = setDressing
        r[SceneField.vfxNames]      = vfx
        r[SceneField.sfxNames]      = sfx
        r[SceneField.sound]          = sound
        r[SceneField.music]          = music

        return r
    }
}
