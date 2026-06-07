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

            Text(
                "\(sceneIndex + 1) / \(totalScenes) Scene"
            )
            .font(.headline)

            Button {

                if sceneIndex < totalScenes - 1 {
                    sceneIndex += 1
                }

            } label: {

                Image(systemName: "chevron.forward")
            }
            .labelStyle(.iconOnly)
        }
      //  .foregroundStyle(.white)
    }
}
