//
//  SceneNavigationView.swift
//  Scene
//

import SwiftUI

struct SceneNavigationView: View {
    @Binding var sceneIndex: Int
    @EnvironmentObject var settings: AppSettings

    let totalScenes: Int

    var body: some View {

        HStack(spacing: 20) {

            Button {

                if sceneIndex > 0 {
                    sceneIndex -= 1
                }

            } label: {

                Image(systemName: "chevron.backward")
            }
            .buttonStyle(.plain)
            .disabled(sceneIndex == 0)


            Text(settings.language == .arabic ? "المشهد \(sceneIndex + 1)" : "Scene \(sceneIndex + 1)")
            .font(.title2)

            Button {

                if sceneIndex < totalScenes - 1 {
                    sceneIndex += 1
                }

            } label: {

                Image(systemName: "chevron.forward")
            }
            .buttonStyle(.plain)
            .disabled(sceneIndex == totalScenes - 1)

        }
        .foregroundStyle(.white)
        .padding(.trailing, 40)
    }
}

