//
//  CloudStorageService.swift
//  Scene
//
//  Created by Yousra Abdelrahman on 19/11/1447 AH.
//

import CloudKit
import Foundation

// MARK: - CloudStorageService
//
// All CloudKit operations go through here. ViewModels call only this.
//
// Query count per operation:
//   loadProjects()         → 1 query
//   loadBreakdown(for:)    → 2 parallel queries (Entities + Scenes)
//   updateCost(...)        → 0 queries — direct fetch by recordID
//   deleteProject(id:)     → 1 delete — cascades to all Entities + Scenes via .deleteSelf

final class CloudStorageService {

    private let db = CKContainer.default().privateCloudDatabase

    // MARK: - Save

    func saveProject(_ project: ProjectModel) async throws {
        try await save([project.toCKRecord()])
    }

    /// Saves the full breakdown for a project.
    /// Entities are saved before scenes because scenes reference entity IDs.
    func saveBreakdown(_ breakdown: ScriptBreakdown, for projectId: String) async throws {
        let projectRef = CKRecord.Reference(
            recordID: CKRecord.ID(recordName: projectId),
            action: .deleteSelf
        )

        // Break down the entity record creation into separate arrays to help the compiler
        let characterRecords = breakdown.totalCharacters.map { $0.toCKRecord(projectId: projectId, projectRef: projectRef) }
        let locationRecords = breakdown.totalLocations.map { $0.toCKRecord(projectId: projectId, projectRef: projectRef) }
        let propRecords = breakdown.totalProps.map { $0.toCKRecord(projectId: projectId, projectRef: projectRef) }
        let vehicleRecords = breakdown.totalVehicles.map { $0.toCKRecord(projectId: projectId, projectRef: projectRef) }
        let animalRecords = breakdown.totalAnimals.map { $0.toCKRecord(projectId: projectId, projectRef: projectRef) }
        let wardrobeRecords = breakdown.totalWardrobe.map { $0.toCKRecord(projectId: projectId, projectRef: projectRef) }
        let makeupRecords = breakdown.totalMakeup.map { $0.toCKRecord(projectId: projectId, projectRef: projectRef) }
        let equipmentRecords = breakdown.totalEquipment.map { $0.toCKRecord(projectId: projectId, projectRef: projectRef) }
        
        let entityRecords: [CKRecord] = characterRecords + locationRecords + propRecords + vehicleRecords + 
                                       animalRecords + wardrobeRecords + makeupRecords + equipmentRecords

        let sceneRecords: [CKRecord] = breakdown.scenes.map { $0.toCKRecord(projectId: projectId) }

        // Entities first, then scenes — scenes store entity IDs so order matters for consistency
        for chunk in (entityRecords + sceneRecords).chunked(into: 400) {
            try await save(chunk)
        }
    }

    // MARK: - Load

    func loadProjects() async throws -> [ProjectModel] {
        let query   = CKQuery(recordType: CloudRecordType.projects, predicate: NSPredicate(value: true))
        let records = try await fetchAll(query)
        return records.compactMap { ProjectModel(ckRecord: $0) }
    }

    /// Loads a full ScriptBreakdown using 2 parallel queries.
    func loadBreakdown(for projectId: String) async throws -> ScriptBreakdown {
        let ref       = CKRecord.Reference(recordID: CKRecord.ID(recordName: projectId), action: .none)
        let predicate = NSPredicate(format: "projectRef == %@", ref)

        async let entityFetch = fetchAll(CKQuery(recordType: CloudRecordType.entities, predicate: predicate))
        async let sceneFetch  = fetchAll(CKQuery(recordType: CloudRecordType.scenes,   predicate: predicate))

        let (entityRecords, sceneRecords) = try await (entityFetch, sceneFetch)

        // Build a typed lookup map from all entity records
        let entityMap = buildEntityMap(from: entityRecords)

        // Reconstruct scenes, resolving stored ID arrays against the map
        let scenes = sceneRecords
            .compactMap { SceneBreakdown(ckRecord: $0, entityMap: entityMap) }
            .sorted { $0.number < $1.number }

        return ScriptBreakdown(
            scenes:          scenes,
            totalCharacters: entityMap.allCharacters,
            totalLocations:  entityMap.allLocations,
            totalProps:      entityMap.allProps,
            totalVehicles:   entityMap.allVehicles,
            totalAnimals:    entityMap.allAnimals,
            totalWardrobe:   entityMap.allWardrobe,
            totalMakeup:     entityMap.allMakeup,
            totalEquipment:  entityMap.allEquipment,
            totalVFX:        [],    // VFX/SFX are stored as resolved name strings on scenes
            totalSFX:        []
        )
    }

    // MARK: - Update cost
    //
    // Direct fetch by recordID — no query needed.
    // Called by BudgetView when the user edits a cost field.

    func updateCost(_ cost: Double, entityId: String, projectId: String) async throws {
        let recordID = CKRecord.ID(recordName: "\(projectId)_\(entityId)")
        let record   = try await db.record(for: recordID)
        record[EntityField.cost] = cost
        try await save([record])
    }

    // MARK: - Update project status

    func updateStatus(_ status: ProjectStatus, projectId: String) async throws {
        let record = try await db.record(for: CKRecord.ID(recordName: projectId))
        record[ProjectField.status] = status.rawValue
        try await save([record])
    }

    // MARK: - Delete
    //
    // Deleting the Projects record cascades automatically to all Entities and Scenes
    // via their .deleteSelf projectRef references. No manual child cleanup needed.

    func deleteProject(id: String) async throws {
        try await db.deleteRecord(withID: CKRecord.ID(recordName: id))
    }

    // MARK: - Private: EntityMap builder

    private func buildEntityMap(from records: [CKRecord]) -> EntityMap {
        var map = EntityMap()
        for record in records {
            guard let type     = record[EntityField.entityType] as? String,
                  let entityId = record[EntityField.entityId]   as? String
            else { continue }

            switch type {
            case EntityType.character: map.characters[entityId] = CharacterBreakdown(ckRecord: record)
            case EntityType.location:  map.locations[entityId]  = LocationBreakdown(ckRecord: record)
            case EntityType.prop:      map.props[entityId]      = PropBreakdown(ckRecord: record)
            case EntityType.vehicle:   map.vehicles[entityId]   = VehicleBreakdown(ckRecord: record)
            case EntityType.animal:    map.animals[entityId]    = AnimalBreakdown(ckRecord: record)
            case EntityType.wardrobe:  map.wardrobe[entityId]   = WardrobeBreakdown(ckRecord: record)
            case EntityType.makeup:    map.makeup[entityId]     = MakeupBreakdown(ckRecord: record)
            case EntityType.equipment: map.equipment[entityId]  = EquipmentBreakdown(ckRecord: record)
            default: break
            }
        }
        return map
    }

    // MARK: - Private: batch save

    private func save(_ records: [CKRecord]) async throws {
        guard !records.isEmpty else { return }
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            let op = CKModifyRecordsOperation(recordsToSave: records, recordIDsToDelete: nil)
            op.savePolicy          = .changedKeys
            op.isAtomic            = false
            op.qualityOfService    = .userInitiated
            op.modifyRecordsResultBlock = { result in
                switch result {
                case .success:          continuation.resume()
                case .failure(let err): continuation.resume(throwing: err)
                }
            }
            db.add(op)
        }
    }

    // MARK: - Private: paginated fetch

    private func fetchAll(_ query: CKQuery) async throws -> [CKRecord] {
        var records: [CKRecord] = []
        var cursor: CKQueryOperation.Cursor?

        let (firstResults, firstCursor) = try await db.records(
            matching: query,
            resultsLimit: CKQueryOperation.maximumResults
        )
        for (_, result) in firstResults {
            if let record = try? result.get() { records.append(record) }
        }
        cursor = firstCursor

        while let active = cursor {
            let (nextResults, nextCursor) = try await db.records(continuingMatchFrom: active)
            for (_, result) in nextResults {
                if let record = try? result.get() { records.append(record) }
            }
            cursor = nextCursor
        }

        return records
    }
}

// MARK: - Array+chunked

private extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
