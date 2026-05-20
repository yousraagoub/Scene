//
//  Item.swift
//  Scene
//
//  Created by Yousra Abdelrahman on 19/11/1447 AH.
//
//
import Foundation
import SwiftData

@Model
final class Itemm {
    var timestamp: Date
    var title: String?// ruam edit
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
