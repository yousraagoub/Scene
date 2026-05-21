//
//  Extensions.swift
//  Scene
//
//  Created by Yousra Abdelrahman on 19/11/1447 AH.
//


import Foundation
import ZIPFoundation

struct Extensions {

    static func extractText(from url: URL) throws -> String {

        let fileManager = FileManager.default

        // 1. Temp folder for unzip
        let unzipFolder = fileManager.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)

        try fileManager.createDirectory(at: unzipFolder, withIntermediateDirectories: true)

        defer {
            try? fileManager.removeItem(at: unzipFolder)
        }

        // 2. Unzip the .docx (it's just a ZIP)
        try fileManager.unzipItem(at: url, to: unzipFolder)

        // 3. Read word/document.xml
        let xmlURL = unzipFolder
            .appendingPathComponent("word")
            .appendingPathComponent("document.xml")

        let xmlData = try Data(contentsOf: xmlURL)

        guard let xmlString = String(data: xmlData, encoding: .utf8) else {
            throw DocumentReaderError.cannotDecodeXML
        }


        let text = xmlString
            .replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
            .replacingOccurrences(of: "&amp;",  with: "&")
            .replacingOccurrences(of: "&lt;",   with: "<")
            .replacingOccurrences(of: "&gt;",   with: ">")
            .replacingOccurrences(of: "&apos;", with: "'")
            .replacingOccurrences(of: "&quot;", with: "\"")
        

        let cleaned = text.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !cleaned.isEmpty else {
            throw DocumentReaderError.emptyDocument
        }

        return cleaned
    }
}

// Errors

enum DocumentReaderError: LocalizedError {
    case cannotDecodeXML
    case emptyDocument

    var errorDescription: String? {
        switch self {
        case .cannotDecodeXML:
            return "Could not decode the document XML. The file may be corrupted."
        case .emptyDocument:
            return "The document appears to be empty."
        }
    }
}
