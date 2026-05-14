//
//  AIService.swift
//  Scene
//
//  Created by Yousra Abdelrahman on 19/11/1447 AH.
//
import Foundation
import OpenAI

final class AIService {
    private let client: OpenAI
    
    init (ApiKey: String) {
        self.client = .init(apiToken: ApiKey)
        
    }
    
    func analyze(
            screenplayText: String,
            completion: @escaping (Result<ScreenplayBreakdown, Error>) -> Void
        ) {
            let query = ScreenplayEndpoint.query(for: screenplayText)
     
            client.chats(query: query) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .failure(let error):
                        completion(.failure(ScreenplayAnalyzerError.apiError(error.localizedDescription)))
     
                    case .success(let response):
                        guard let rawContent = response.choices.first?.message.content else {
                            completion(.failure(ScreenplayAnalyzerError.noContent))
                            return
                        }
     
                        let cleaned = Self.stripMarkdownFences(from: rawContent)
     
                        guard let data = cleaned.data(using: .utf8) else {
                            completion(.failure(ScreenplayAnalyzerError.invalidJSON("Could not encode response to Data.")))
                            return
                        }
     
                        do {
                            let breakdown = try JSONDecoder().decode(ScreenplayBreakdown.self, from: data)
                            completion(.success(breakdown))
                        } catch {
                            completion(.failure(ScreenplayAnalyzerError.invalidJSON(error.localizedDescription)))
                        }
                    }
                }
            }
        }
     
        //  Async/Await
     
        func analyze(screenplayText: String) async throws -> ScreenplayBreakdown {
            try await withCheckedThrowingContinuation { continuation in
                analyze(screenplayText: screenplayText) { result in
                    continuation.resume(with: result)
                }
            }
        }
     
        // Helpers
     
        private static func stripMarkdownFences(from text: String) -> String {
            var result = text.trimmingCharacters(in: .whitespacesAndNewlines)
            if result.hasPrefix("```") {
                if let newlineRange = result.range(of: "\n") {
                    result = String(result[newlineRange.upperBound...])
                }
                if result.hasSuffix("```") {
                    result = String(result.dropLast(3))
                }
            }
            return result.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
     
