//
//  BreakdownView.swift
//  Scene
//

import SwiftUI

struct BreakdownView: View {

    let project: ProjectModel

    var body: some View {

        VStack(alignment: .leading, spacing: 20) {
            Text(project.title)
                .font(.largeTitle)
                .foregroundColor(.white)

            Text(project.genre)
                .foregroundColor(.secondary)

            Text(project.scriptType.rawValue)
                .foregroundColor(.secondary)

            Spacer()

            Text("Script Breakdown Placeholder")
                .font(.title2)
                .foregroundColor(.white)
        }
        .padding()
    }
}
