//
//  CloudStorageService.swift
//  Scene
//
//  Created by Yousra Abdelrahman on 19/11/1447 AH.
//

import CloudKit
import Foundation

// MARK: - Protocol

protocol CloudStorageServiceProtocol {
    func checkAccountStatus() async throws -> CKAccountStatus

    // Projects
    func saveProject(_ project: CloudProject) async throws -> CloudProject
    func fetchProjects() async throws -> [CloudProject]
    func fetchProject(recordName: String) async throws -> CloudProject
    func updateProject(_ project: CloudProject) async throws -> CloudProject
    func deleteProject(recordName: String) async throws

    // Production Entities — created by AI, never edited by user
    func saveProductionEntities(_ entities: [CloudProductionEntity]) async throws -> [CloudProductionEntity]
    func fetchProductionEntities(projectRecordName: String) async throws -> [CloudProductionEntity]

    // Budget Entries — created by user, editable
    func saveBudgetEntry(_ entry: CloudBudgetEntry) async throws -> CloudBudgetEntry
    func fetchBudgetEntries(projectRecordName: String) async throws -> [CloudBudgetEntry]
    func updateBudgetEntry(_ entry: CloudBudgetEntry) async throws -> CloudBudgetEntry
    func deleteBudgetEntry(recordName: String) async throws

    // Scenes — created by AI, never edited by user
    func saveScenes(_ scenes: [CloudScene]) async throws -> [CloudScene]
    func fetchScenes(projectRecordName: String) async throws -> [CloudScene]
}

// MARK: - Project Status

enum ProjectStatus: String {
    case pending    // created, no script yet
    case analyzing  // script uploaded, AI running
    case ready      // analysis complete
    case failed     // analysis failed
}

// MARK: - Cloud Models

struct CloudProject {
    var recordID: CKRecord.ID?
    var title: String
    var description: String
    var scriptFileData: Data?       // set before upload
    var scriptFileURL: URL?         // populated after fetch
    var breakdownFileData: Data?    // set after AI analysis (JSON as Data)
    var breakdownFileURL: URL?      // populated after fetch
    var status: ProjectStatus
    var totalBudget: Double
    var createdAt: Date
    var updatedAt: Date
}

/// Represents a single production element extracted by the AI from the screenplay.
/// Created automatically — never manually edited by the user.
struct CloudProductionEntity {
    var recordID: CKRecord.ID?
    var projectReference: CKRecord.Reference
    var sourceID: String            // AI's entity ID e.g. "char_001"
    var name: String
    var category: EntityCategory
    var detailsJSON: String         // aliases, traits, type, department, etc.

    enum EntityCategory: String, CaseIterable {
        case cast, location, props, wardrobe, makeup,
             vehicles, equipment, vfx, sfx, animals, setDressing
    }
}

/// Represents a cost assigned to a production entity by the user.
/// Created manually — fully editable.
struct CloudBudgetEntry {
    var recordID: CKRecord.ID?
    var projectReference: CKRecord.Reference
    var entityReference: CKRecord.Reference  // → ProductionEntity
    var cost: Double
    var notes: String
}

/// Represents a scene extracted by the AI from the screenplay.
/// Created automatically — never manually edited by the user.
struct CloudScene {
    var recordID: CKRecord.ID?
    var projectReference: CKRecord.Reference
    var sourceID: String                        // AI's sceneId e.g. "scene_001"
    var sceneNumber: Int
    var heading: String
    var time: String
    var locationReference: CKRecord.Reference?  // → ProductionEntity (category: location)
    var castItems: [CKRecord.Reference]         // → ProductionEntities (performance layer)
    var productionItems: [CKRecord.Reference]   // → ProductionEntities (production layer)
    var postItems: [CKRecord.Reference]         // → ProductionEntities (post layer)
}

// MARK: - Error

enum CloudStorageError: LocalizedError {
    case notSignedIn
    case recordNotFound(String)
    case encodingFailed
    case decodingFailed(String)
    case saveFailed(String)
    case deleteFailed(String)
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .notSignedIn:             return "iCloud account not signed in."
        case .recordNotFound(let id):  return "Record not found: \(id)"
        case .encodingFailed:          return "Failed to encode data for upload."
        case .decodingFailed(let d):   return "Failed to decode cloud record: \(d)"
        case .saveFailed(let d):       return "Save failed: \(d)"
        case .deleteFailed(let d):     return "Delete failed: \(d)"
        case .unknown(let e):          return "Unexpected error: \(e.localizedDescription)"
        }
    }
}

// MARK: - Field Keys

private enum RecordType {
    static let project          = "Projects"
    static let productionEntity = "ProductionEntities"
    static let budgetEntry      = "BudgetItems"
    static let scene            = "Scene"
}

private enum ProjectField {
    static let title         = "title"
    static let description   = "description"
    static let scriptFile    = "script_file"
    static let breakdownFile = "breakdown_file"   // CKAsset — not a String
    static let status        = "status"
    static let totalBudget   = "total_budget"
    static let createdAt     = "created_at"
    static let updatedAt     = "updated_at"
}

private enum ProductionEntityField {
    static let project     = "project"
    static let sourceID    = "source_id"
    static let name        = "name"
    static let category    = "category"
    static let detailsJSON = "details_json"
}

private enum BudgetEntryField {
    static let project = "project"
    static let entity  = "entity"
    static let cost    = "cost"
    static let notes   = "notes"
}

private enum SceneField {
    static let project         = "project"
    static let sourceID        = "source_id"
    static let sceneNumber     = "scene_number"
    static let heading         = "heading"
    static let time            = "time"
    static let location        = "location"
    static let castItems       = "cast_items"
    static let productionItems = "production_items"
    static let postItems       = "post_items"
}

// MARK: - Service

final class CloudStorageService: CloudStorageServiceProtocol {

    private let container: CKContainer
    private let privateDB: CKDatabase

    init(containerIdentifier: String? = nil) {
        container = containerIdentifier.map(CKContainer.init) ?? .default()
        privateDB = container.privateCloudDatabase
    }

    // MARK: - Account

    func checkAccountStatus() async throws -> CKAccountStatus {
        let status = try await container.accountStatus()
        guard status == .available else { throw CloudStorageError.notSignedIn }
        return status
    }

    // MARK: - Projects

    func saveProject(_ project: CloudProject) async throws -> CloudProject {
        let record = CKRecord(recordType: RecordType.project)
        try populate(record, from: project)
        do { return try mapProject(from: try await privateDB.save(record)) }
        catch { throw CloudStorageError.saveFailed(error.localizedDescription) }
    }

    func fetchProjects() async throws -> [CloudProject] {
        let query = CKQuery(recordType: RecordType.project, predicate: NSPredicate(value: true))
        query.sortDescriptors = [NSSortDescriptor(key: ProjectField.updatedAt, ascending: false)]
        let (results, _) = try await privateDB.records(matching: query)
        return try results.compactMap { _, result in
            guard case .success(let r) = result else { return nil }
            return try mapProject(from: r)
        }
    }

    func fetchProject(recordName: String) async throws -> CloudProject {
        try mapProject(from: try await privateDB.record(for: CKRecord.ID(recordName: recordName)))
    }

    func updateProject(_ project: CloudProject) async throws -> CloudProject {
        guard let recordID = project.recordID else { return try await saveProject(project) }
        let record = try await privateDB.record(for: recordID)
        record[ProjectField.title]       = project.title
        record[ProjectField.description] = project.description
        record[ProjectField.status]      = project.status.rawValue
        record[ProjectField.totalBudget] = project.totalBudget
        record[ProjectField.updatedAt]   = Date()
        if let data = project.scriptFileData {
            record[ProjectField.scriptFile] = try makeAsset(from: data, name: "\(recordID.recordName)_script")
        }
        if let data = project.breakdownFileData {
            record[ProjectField.breakdownFile] = try makeAsset(from: data, name: "\(recordID.recordName)_breakdown")
        }
        do { return try mapProject(from: try await privateDB.save(record)) }
        catch { throw CloudStorageError.saveFailed(error.localizedDescription) }
    }

    func deleteProject(recordName: String) async throws {
        // Cascade: ProductionEntities, BudgetEntries, Scenes with .deleteSelf auto-deleted
        do { try await privateDB.deleteRecord(withID: CKRecord.ID(recordName: recordName)) }
        catch { throw CloudStorageError.deleteFailed(error.localizedDescription) }
    }

    // MARK: - Production Entities

    func saveProductionEntities(_ entities: [CloudProductionEntity]) async throws -> [CloudProductionEntity] {
        let records = entities.map { entity -> CKRecord in
            let r = CKRecord(recordType: RecordType.productionEntity)
            populate(r, from: entity)
            return r
        }
        let results = try await privateDB.modifyRecords(saving: records, deleting: [])
        return try results.saveResults.compactMap { _, result in
            guard case .success(let r) = result else { return nil }
            return try mapProductionEntity(from: r)
        }
    }

    func fetchProductionEntities(projectRecordName: String) async throws -> [CloudProductionEntity] {
        let ref = CKRecord.Reference(recordID: CKRecord.ID(recordName: projectRecordName), action: .none)
        let predicate = NSPredicate(format: "%K == %@", ProductionEntityField.project, ref)
        let query = CKQuery(recordType: RecordType.productionEntity, predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: ProductionEntityField.name, ascending: true)]
        let (results, _) = try await privateDB.records(matching: query)
        return try results.compactMap { _, result in
            guard case .success(let r) = result else { return nil }
            return try mapProductionEntity(from: r)
        }
    }

    // MARK: - Budget Entries

    func saveBudgetEntry(_ entry: CloudBudgetEntry) async throws -> CloudBudgetEntry {
        let record = CKRecord(recordType: RecordType.budgetEntry)
        populate(record, from: entry)
        do { return try mapBudgetEntry(from: try await privateDB.save(record)) }
        catch { throw CloudStorageError.saveFailed(error.localizedDescription) }
    }

    func fetchBudgetEntries(projectRecordName: String) async throws -> [CloudBudgetEntry] {
        let ref = CKRecord.Reference(recordID: CKRecord.ID(recordName: projectRecordName), action: .none)
        let predicate = NSPredicate(format: "%K == %@", BudgetEntryField.project, ref)
        let query = CKQuery(recordType: RecordType.budgetEntry, predicate: predicate)
        let (results, _) = try await privateDB.records(matching: query)
        return try results.compactMap { _, result in
            guard case .success(let r) = result else { return nil }
            return try mapBudgetEntry(from: r)
        }
    }

    func updateBudgetEntry(_ entry: CloudBudgetEntry) async throws -> CloudBudgetEntry {
        guard let recordID = entry.recordID else { return try await saveBudgetEntry(entry) }
        let record = try await privateDB.record(for: recordID)
        record[BudgetEntryField.cost]  = entry.cost
        record[BudgetEntryField.notes] = entry.notes
        do { return try mapBudgetEntry(from: try await privateDB.save(record)) }
        catch { throw CloudStorageError.saveFailed(error.localizedDescription) }
    }

    func deleteBudgetEntry(recordName: String) async throws {
        do { try await privateDB.deleteRecord(withID: CKRecord.ID(recordName: recordName)) }
        catch { throw CloudStorageError.deleteFailed(error.localizedDescription) }
    }

    // MARK: - Scenes

    func saveScenes(_ scenes: [CloudScene]) async throws -> [CloudScene] {
        let records = scenes.map { scene -> CKRecord in
            let r = CKRecord(recordType: RecordType.scene)
            populate(r, from: scene)
            return r
        }
        let results = try await privateDB.modifyRecords(saving: records, deleting: [])
        return try results.saveResults.compactMap { _, result in
            guard case .success(let r) = result else { return nil }
            return try mapScene(from: r)
        }
    }

    func fetchScenes(projectRecordName: String) async throws -> [CloudScene] {
        let ref = CKRecord.Reference(recordID: CKRecord.ID(recordName: projectRecordName), action: .none)
        let predicate = NSPredicate(format: "%K == %@", SceneField.project, ref)
        let query = CKQuery(recordType: RecordType.scene, predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: SceneField.sceneNumber, ascending: true)]
        let (results, _) = try await privateDB.records(matching: query)
        return try results.compactMap { _, result in
            guard case .success(let r) = result else { return nil }
            return try mapScene(from: r)
        }
    }
}

// MARK: - Record Populators

private extension CloudStorageService {

    func populate(_ record: CKRecord, from project: CloudProject) throws {
        record[ProjectField.title]       = project.title
        record[ProjectField.description] = project.description
        record[ProjectField.status]      = project.status.rawValue
        record[ProjectField.totalBudget] = project.totalBudget
        record[ProjectField.createdAt]   = project.createdAt
        record[ProjectField.updatedAt]   = project.updatedAt
        let name = record.recordID.recordName
        if let data = project.scriptFileData {
            record[ProjectField.scriptFile] = try makeAsset(from: data, name: "\(name)_script")
        }
        if let data = project.breakdownFileData {
            record[ProjectField.breakdownFile] = try makeAsset(from: data, name: "\(name)_breakdown")
        }
    }

    func populate(_ record: CKRecord, from entity: CloudProductionEntity) {
        record[ProductionEntityField.project] = CKRecord.Reference(
            recordID: entity.projectReference.recordID, action: .deleteSelf
        )
        record[ProductionEntityField.sourceID]    = entity.sourceID
        record[ProductionEntityField.name]        = entity.name
        record[ProductionEntityField.category]    = entity.category.rawValue
        record[ProductionEntityField.detailsJSON] = entity.detailsJSON
    }

    func populate(_ record: CKRecord, from entry: CloudBudgetEntry) {
        record[BudgetEntryField.project] = CKRecord.Reference(
            recordID: entry.projectReference.recordID, action: .deleteSelf
        )
        record[BudgetEntryField.entity] = CKRecord.Reference(
            recordID: entry.entityReference.recordID, action: .none
        )
        record[BudgetEntryField.cost]  = entry.cost
        record[BudgetEntryField.notes] = entry.notes
    }

    func populate(_ record: CKRecord, from scene: CloudScene) {
        record[SceneField.project] = CKRecord.Reference(
            recordID: scene.projectReference.recordID, action: .deleteSelf
        )
        record[SceneField.sourceID]    = scene.sourceID
        record[SceneField.sceneNumber] = scene.sceneNumber
        record[SceneField.heading]     = scene.heading
        record[SceneField.time]        = scene.time
        record[SceneField.location]    = scene.locationReference
        record[SceneField.castItems] = scene.castItems.map {
            CKRecord.Reference(recordID: $0.recordID, action: .none)
        }
        record[SceneField.productionItems] = scene.productionItems.map {
            CKRecord.Reference(recordID: $0.recordID, action: .none)
        }
        record[SceneField.postItems] = scene.postItems.map {
            CKRecord.Reference(recordID: $0.recordID, action: .none)
        }
    }
}

// MARK: - CKRecord → Model Mappers

private extension CloudStorageService {

    func mapProject(from record: CKRecord) throws -> CloudProject {
        guard
            let title       = record[ProjectField.title]       as? String,
            let description = record[ProjectField.description] as? String,
            let statusRaw   = record[ProjectField.status]      as? String,
            let status      = ProjectStatus(rawValue: statusRaw),
            let totalBudget = record[ProjectField.totalBudget] as? Double,
            let createdAt   = record[ProjectField.createdAt]   as? Date,
            let updatedAt   = record[ProjectField.updatedAt]   as? Date
        else {
            throw CloudStorageError.decodingFailed("Projects record has missing required fields.")
        }
        return CloudProject(
            recordID:          record.recordID,
            title:             title,
            description:       description,
            scriptFileURL:     (record[ProjectField.scriptFile]    as? CKAsset)?.fileURL,
            breakdownFileURL:  (record[ProjectField.breakdownFile] as? CKAsset)?.fileURL,
            status:            status,
            totalBudget:       totalBudget,
            createdAt:         createdAt,
            updatedAt:         updatedAt
        )
    }

    func mapProductionEntity(from record: CKRecord) throws -> CloudProductionEntity {
        guard
            let ref         = record[ProductionEntityField.project]     as? CKRecord.Reference,
            let sourceID    = record[ProductionEntityField.sourceID]    as? String,
            let name        = record[ProductionEntityField.name]        as? String,
            let categoryRaw = record[ProductionEntityField.category]    as? String,
            let detailsJSON = record[ProductionEntityField.detailsJSON] as? String,
            let category    = CloudProductionEntity.EntityCategory(rawValue: categoryRaw)
        else {
            throw CloudStorageError.decodingFailed("ProductionEntities record has missing required fields.")
        }
        return CloudProductionEntity(
            recordID:         record.recordID,
            projectReference: ref,
            sourceID:         sourceID,
            name:             name,
            category:         category,
            detailsJSON:      detailsJSON
        )
    }

    func mapBudgetEntry(from record: CKRecord) throws -> CloudBudgetEntry {
        guard
            let projectRef = record[BudgetEntryField.project] as? CKRecord.Reference,
            let entityRef  = record[BudgetEntryField.entity]  as? CKRecord.Reference,
            let cost       = record[BudgetEntryField.cost]    as? Double
        else {
            throw CloudStorageError.decodingFailed("BudgetEntries record has missing required fields.")
        }
        return CloudBudgetEntry(
            recordID:         record.recordID,
            projectReference: projectRef,
            entityReference:  entityRef,
            cost:             cost,
            notes:            record[BudgetEntryField.notes] as? String ?? ""
        )
    }

    func mapScene(from record: CKRecord) throws -> CloudScene {
        guard
            let ref         = record[SceneField.project]     as? CKRecord.Reference,
            let sourceID    = record[SceneField.sourceID]    as? String,
            let sceneNumber = record[SceneField.sceneNumber] as? Int,
            let heading     = record[SceneField.heading]     as? String,
            let time        = record[SceneField.time]        as? String
        else {
            throw CloudStorageError.decodingFailed("Scene record has missing required fields.")
        }
        return CloudScene(
            recordID:          record.recordID,
            projectReference:  ref,
            sourceID:          sourceID,
            sceneNumber:       sceneNumber,
            heading:           heading,
            time:              time,
            locationReference: record[SceneField.location]         as? CKRecord.Reference,
            castItems:         record[SceneField.castItems]         as? [CKRecord.Reference] ?? [],
            productionItems:   record[SceneField.productionItems]   as? [CKRecord.Reference] ?? [],
            postItems:         record[SceneField.postItems]         as? [CKRecord.Reference] ?? []
        )
    }
}

// MARK: - Helpers

private extension CloudStorageService {

    func makeAsset(from data: Data, name: String) throws -> CKAsset {
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent(name)
            .appendingPathExtension("dat")
        do { try data.write(to: url) } catch { throw CloudStorageError.encodingFailed }
        return CKAsset(fileURL: url)
    }
}
