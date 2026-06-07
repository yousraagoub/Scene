//
//  ScreenplayBreakdownConverter.swift
//  Scene
//
//  Created by ruam on 21/12/1447 AH.
//


import Foundation

extension ScreenplayBreakdown {

    /// Converts the AI's raw ScreenplayBreakdown into the UI-facing ScriptBreakdown.
    ///
    /// - Total arrays are built from productionEntities directly (not by collapsing scenes)
    ///   because the AI already deduplicates globally. This guarantees every entity appears
    ///   in the budget even if a scene only references it by ID.
    /// - AI entity IDs are preserved as-is — they become CloudKit recordName suffixes.
    /// - cost starts at 0 for all entities. BudgetView writes cost; CloudKit persists it.

    func toScriptBreakdown() -> ScriptBreakdown {

        // MARK: Scenes

        let scenes: [SceneBreakdown] = self.scenes.enumerated().map { index, scene in

            let characters: [CharacterBreakdown] = scene.sceneLayers.performance.cast.compactMap { member in
                guard let entity = productionEntities.characters.first(where: { $0.characterId == member.characterId })
                else { return nil }
                return CharacterBreakdown(
                    id:            entity.characterId,
                    name:          entity.canonicalName,
                    aliases:       entity.aliases,
                    stateInScene:  member.state,
                    stuntsInScene: member.stunt
                )
            }

            let locations: [LocationBreakdown] = {
                guard let entity = productionEntities.locations.first(where: { $0.locationId == scene.locationId })
                else { return [] }
                return [LocationBreakdown(id: entity.locationId, name: entity.name, type: entity.type)]
            }()

            let props: [PropBreakdown] = scene.sceneLayers.production.props.compactMap { propId in
                guard let entity = productionEntities.props.first(where: { $0.propId == propId })
                else { return PropBreakdown(id: propId, name: propId, category: "unknown") }
                return PropBreakdown(id: entity.propId, name: entity.name, category: entity.category)
            }

            let vehicles: [VehicleBreakdown] = scene.sceneLayers.production.vehicles.compactMap { vehicleId in
                guard let entity = productionEntities.vehicles.first(where: { $0.vehicleId == vehicleId })
                else { return nil }
                return VehicleBreakdown(id: entity.vehicleId, name: entity.name, type: entity.type)
            }

            let animals: [AnimalBreakdown] = scene.sceneLayers.performance.animals.compactMap { animalId in
                guard let entity = productionEntities.animals.first(where: { $0.animalId == animalId })
                else { return nil }
                return AnimalBreakdown(id: entity.animalId, name: entity.name)
            }

            let wardrobe: [WardrobeBreakdown] = scene.sceneLayers.production.wardrobe.compactMap { wardrobeId in
                guard let entity = productionEntities.wardrobe.first(where: { $0.wardrobeId == wardrobeId })
                else { return nil }
                return WardrobeBreakdown(id: entity.wardrobeId, name: entity.name)
            }

            let makeup: [MakeupBreakdown] = scene.sceneLayers.production.makeup.compactMap { makeupId in
                guard let entity = productionEntities.makeup.first(where: { $0.makeupId == makeupId })
                else { return nil }
                return MakeupBreakdown(id: entity.makeupId, name: entity.name)
            }

            let equipment: [EquipmentBreakdown] = scene.sceneLayers.production.equipment.compactMap { equipmentId in
                guard let entity = productionEntities.equipment.first(where: { $0.equipmentId == equipmentId })
                else { return nil }
                return EquipmentBreakdown(id: entity.equipmentId, name: entity.name, department: entity.department)
            }

            let vfx: [String] = scene.sceneLayers.post.vfx.map { vfxId in
                productionEntities.vfxAssets.first(where: { $0.vfxId == vfxId })?.name ?? vfxId
            }

            let sfx: [String] = scene.sceneLayers.post.sfx.map { sfxId in
                productionEntities.sfxAssets.first(where: { $0.sfxId == sfxId })?.name ?? sfxId
            }

            return SceneBreakdown(
                id:          scene.sceneId,
                number:      index + 1,
                heading:     scene.heading,
                time:        scene.time,
                characters:  characters,
                locations:   locations,
                props:       props,
                vehicles:    vehicles,
                animals:     animals,
                wardrobe:    wardrobe,
                makeup:      makeup,
                equipment:   equipment,
                setDressing: scene.sceneLayers.production.setDressing,
                vfx:         vfx,
                sfx:         sfx,
                sound:       scene.sceneLayers.post.sound,
                music:       scene.sceneLayers.post.music
            )
        }

        // MARK: Totals — built from productionEntities, not from scenes

        return ScriptBreakdown(
            scenes:          scenes,
            totalCharacters: productionEntities.characters.map {
                CharacterBreakdown(id: $0.characterId, name: $0.canonicalName, aliases: $0.aliases)
            },
            totalLocations: productionEntities.locations.map {
                LocationBreakdown(id: $0.locationId, name: $0.name, type: $0.type)
            },
            totalProps: productionEntities.props.map {
                PropBreakdown(id: $0.propId, name: $0.name, category: $0.category)
            },
            totalVehicles: productionEntities.vehicles.map {
                VehicleBreakdown(id: $0.vehicleId, name: $0.name, type: $0.type)
            },
            totalAnimals: productionEntities.animals.map {
                AnimalBreakdown(id: $0.animalId, name: $0.name)
            },
            totalWardrobe: productionEntities.wardrobe.map {
                WardrobeBreakdown(id: $0.wardrobeId, name: $0.name)
            },
            totalMakeup: productionEntities.makeup.map {
                MakeupBreakdown(id: $0.makeupId, name: $0.name)
            },
            totalEquipment: productionEntities.equipment.map {
                EquipmentBreakdown(id: $0.equipmentId, name: $0.name, department: $0.department)
            },
            totalVFX: productionEntities.vfxAssets.map(\.name),
            totalSFX: productionEntities.sfxAssets.map(\.name)
        )
    }
}
