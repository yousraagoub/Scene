//
//  BudgetSegmentShape.swift
//  Scene
//
//  Created by Yousra Abdelrahman on 08/01/1448 AH.
//
import SwiftUI

struct BudgetSegmentShape: Shape {

    let startAngle: Angle
    let endAngle: Angle

    func path(in rect: CGRect) -> Path {

        let radius = min(rect.width, rect.height) / 2
        let center = CGPoint(
            x: rect.midX,
            y: rect.midY
        )

        var path = Path()

        path.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: false
        )

        return path
    }
}
