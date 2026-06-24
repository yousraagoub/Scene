//
//  SceneProject.swift
//  Scene
//

import CloudKit
import Foundation

struct ProjectModel: Identifiable {
    let id:         String
    var title:      String
    var genre:      String
    var scriptType: ScriptType
    var status:     ProjectStatus
    var createdAt:  Date
    var fileURL:    URL?
}

// MARK: - Enums

enum ScriptType: String, CaseIterable {
    case film   = "Film"
    case series = "Series"
}


enum ProjectStatus: String {
    case draft      // created, no screenplay uploaded yet
    case analyzing  // AI call in progress
    case ready      // breakdown saved to CloudKit
    case error      // analysis or save failed
}

// MARK: - CloudKit
//
// Defined in an extension so Swift keeps the memberwise initializer on the struct.

extension ProjectModel {

    init?(ckRecord: CKRecord) {
        guard
            let title     = ckRecord[ProjectField.title]      as? String,
            let genre     = ckRecord[ProjectField.genre]      as? String,
            let typeRaw   = ckRecord[ProjectField.scriptType] as? String,
            let statusRaw = ckRecord[ProjectField.status]     as? String,
            let createdAt = ckRecord[ProjectField.createdAt]  as? Date,
            let type      = ScriptType(rawValue: typeRaw),
            let status    = ProjectStatus(rawValue: statusRaw)
        else { return nil }

        self.id         = ckRecord.recordID.recordName
        self.title      = title
        self.genre      = genre
        self.scriptType = type
        self.status     = status
        self.createdAt  = createdAt
        self.fileURL    = nil
    }

    func toCKRecord() -> CKRecord {
        let r = CKRecord(recordType: CloudRecordType.projects,
                         recordID: CKRecord.ID(recordName: id))
        r[ProjectField.title]      = title
        r[ProjectField.genre]      = genre
        r[ProjectField.scriptType] = scriptType.rawValue
        r[ProjectField.status]     = status.rawValue
        r[ProjectField.createdAt]  = createdAt
        return r
    }
}
