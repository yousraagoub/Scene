//
//  Item.swift
//  Scene
//
//  Created by Yousra Abdelrahman on 19/11/1447 AH.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
