//
//  SceneNavigationView.swift
//  Scene
//
import SwiftUI

struct SceneNavigationView: View {

    @Binding var sceneIndex: Int

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


            Text(
                "\(sceneIndex + 1) out of \(totalScenes)"
            )
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
    }
}
