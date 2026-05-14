//
//  BackgroundView.swift
//  Scene
//
import SwiftUI

struct BackgroundView<Content: View>: View {

    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ZStack {
            BackgroundGradients.primary
                .ignoresSafeArea()

            content
        }
    }
}
