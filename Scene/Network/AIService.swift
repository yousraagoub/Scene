//
//  AIService.swift
//  Scene
//
//  Created by Yousra Abdelrahman on 19/11/1447 AH.
//
import Foundation
//import OpenAI
final class AIService {

    private let apiKey: String

    init(ApiKey: String) {
        self.apiKey = ApiKey
    }

    func analyze(
        screenplayText: String,
        completion: @escaping (Result<ScreenplayBreakdown, Error>) -> Void
    ) {

        Task {

            do {

                let url = URL(string: "https://api.openai.com/v1/chat/completions")!

                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")

                let body: [String: Any] = [
                    "model": "gpt-4o",
                    "messages": [
                        [
                            "role": "system",
                            "content": ScreenplayEndpoint.systemPrompt
                        ],
                        [
                            "role": "user",
                            "content": screenplayText
                        ]
                    ],
                    "temperature": 0
                ]

                request.httpBody = try JSONSerialization.data(
                                    withJSONObject: ScreenplayEndpoint.requestBody(for: screenplayText)
                                )
                let (data, _) = try await URLSession.shared.data(for: request)
                if let obj = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   obj["error"] != nil {
                    throw ScreenplayAnalyzerError.apiError("\(obj)")
                }

                let response = try JSONDecoder().decode(ChatResponse.self, from: data)

                guard let content = response.choices.first?.message.content else {
                    throw ScreenplayAnalyzerError.noContent
                }
//                if let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
//                   jsonObject["error"] != nil {
//                    throw ScreenplayAnalyzerError.apiError("API returned error: \(jsonObject)")
//                }
//                let response = try JSONDecoder().decode(ChatResponse.self, from: data)
//                guard let content = response.choices.first?.message.content else {
//                    throw ScreenplayAnalyzerError.noContent
//                }

//                let response = try JSONDecoder().decode(ChatResponse.self, from: data)
//
//                guard let content = response.choices.first?.message.content else {
//                    throw ScreenplayAnalyzerError.noContent
//                    // I am not 100%
//                    if let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
//                       jsonObject["error"] != nil {
//                        throw ScreenplayAnalyzerError.apiError("API returned error: \(jsonObject)")
//                    }//
              // }
                let cleaned = Self.stripMarkdownFences(from: content)

                let jsonData = Data(cleaned.utf8)

                let breakdown = try JSONDecoder().decode(ScreenplayBreakdown.self, from: jsonData)

                DispatchQueue.main.async {
                    completion(.success(breakdown))
                }

            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    func analyze(screenplayText: String) async throws -> ScreenplayBreakdown {
        try await withCheckedThrowingContinuation { continuation in
            analyze(screenplayText: screenplayText) { result in
                continuation.resume(with: result)
            }
        }
    }

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
