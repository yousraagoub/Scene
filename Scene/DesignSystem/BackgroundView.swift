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
//            Color.appBackground.ignoresSafeArea()
//            VStack {
//                Spacer()
//                Image("gradientImg")
//                    .resizable()
//                    .scaledToFit()
//            }
            BackgroundGradients.primary
                .ignoresSafeArea()
            
            content
        }
    }
}
