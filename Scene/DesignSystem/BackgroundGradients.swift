//
//  BackgroundGradients.swift
//  Scene
//
import SwiftUI

enum BackgroundGradients {
    
    static let primary = LinearGradient(
        colors: [
            Color.appBackground,
            Color.gradientMix
        ],
        startPoint: .top,
        endPoint: .bottom
    )
    
}
