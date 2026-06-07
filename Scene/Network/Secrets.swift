//
//  Secrets.swift
//  Scene
//
//  NOTE: Do not commit real API keys to source control.
//

import Foundation

enum Secrets {

    // Development convenience: hardcode during local testing.
    // Replace with your actual key, or switch to the Info.plist loader below.
    static let openAIKey: String = {
        // return "<YOUR_OPENAI_API_KEY>"

        // Recommended: load from Info.plist
        guard let key = Bundle.main.object(forInfoDictionaryKey: "OPENAI_API_KEY") as? String,
              key.isEmpty == false else {
            // Fail fast so the issue is obvious during development.
            fatalError("Missing OPENAI_API_KEY in Info.plist. Add it or hardcode the key in Secrets.openAIKey.")
        }
        return key
    }()
}
