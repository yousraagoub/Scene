import Foundation

struct ScriptBreakdown {

    var scenes: [SceneBreakdown]

    var totalCharacters: [CharacterBreakdown]

    var totalLocations: [LocationBreakdown]

    var totalProps: [PropBreakdown]

    var totalVisualEffects: [String]
}

struct SceneBreakdown: Identifiable {

    let id = UUID()

    let number: Int

    let title: String

    let characters: [CharacterBreakdown]

    let locations: [LocationBreakdown]

    let props: [PropBreakdown]

    let visualEffects: [String]
}

struct CharacterBreakdown: Identifiable {

    let id = UUID()

    let name: String

    let role: String
}

struct LocationBreakdown: Identifiable {

    let id = UUID()

    let name: String

    let type: String
}

struct PropBreakdown: Identifiable {

    let id = UUID()

    let name: String
}
