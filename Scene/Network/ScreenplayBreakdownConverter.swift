//
//  ScreenplayBreakdownConverter.swift
//  Scene
//
//  Created by ruam on 21/12/1447 AH.
//


import Foundation

extension ScreenplayBreakdown {

    func toScriptBreakdown() -> ScriptBreakdown {

        // Map each AI scene into a SceneBreakdown the UI already understands
        let scenes: [SceneBreakdown] = self.scenes.enumerated().map { index, scene in

            // Characters present in this scene
            let characters: [CharacterBreakdown] = scene.sceneLayers.performance.cast.compactMap { castMember in
                // Look up the character's name from productionEntities using their ID
                guard let entity = self.productionEntities.characters.first(
                    where: { $0.characterId == castMember.characterId }
                ) else { return nil }

                return CharacterBreakdown(
                    name: entity.canonicalName,
                    role: castMember.state.first ?? "Cast"
                )
            }

            // Props used in this scene
            let props: [PropBreakdown] = scene.sceneLayers.production.props.compactMap { propId in
                guard let entity = self.productionEntities.props.first(
                    where: { $0.propId == propId }
                ) else {
                    // If it's not an ID but a raw name, use it directly
                    return PropBreakdown(name: propId)
                }
                return PropBreakdown(name: entity.name)
            }

            // Location for this scene
            let locations: [LocationBreakdown] = {
                guard let entity = self.productionEntities.locations.first(
                    where: { $0.locationId == scene.locationId }
                ) else { return [] }
                return [LocationBreakdown(name: entity.name, type: entity.type)]
            }()

            // VFX as visual effects strings
            let vfx = scene.sceneLayers.post.vfx.compactMap { vfxId in
                self.productionEntities.vfxAssets.first(where: { $0.vfxId == vfxId })?.name ?? vfxId
            }

            return SceneBreakdown(
                number: index + 1,
                title: scene.heading,
                characters: characters,
                locations: locations,
                props: props,
                visualEffects: vfx
            )
        }

        // Roll up totals across all scenes (deduplicated by name)
        let allCharacters = scenes.flatMap { $0.characters }
        let uniqueCharacters = Array(
            Dictionary(grouping: allCharacters, by: { $0.name })
                .compactMapValues { $0.first }
                .values
        )

        let allLocations = scenes.flatMap { $0.locations }
        let uniqueLocations = Array(
            Dictionary(grouping: allLocations, by: { $0.name })
                .compactMapValues { $0.first }
                .values
        )

        let allProps = scenes.flatMap { $0.props }
        let uniqueProps = Array(
            Dictionary(grouping: allProps, by: { $0.name })
                .compactMapValues { $0.first }
                .values
        )

        let allVFX = Array(Set(scenes.flatMap { $0.visualEffects }))

        return ScriptBreakdown(
            scenes: scenes,
            totalCharacters: uniqueCharacters,
            totalLocations: uniqueLocations,
            totalProps: uniqueProps,
            totalVisualEffects: allVFX
        )
    }
}
