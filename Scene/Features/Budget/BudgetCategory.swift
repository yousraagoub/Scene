//
//  BudgetCategory.swift
//  Scene
//
//  Created by Yousra Abdelrahman on 08/01/1448 AH.
//
import SwiftUI

struct BudgetCategory: Identifiable {
    let id = UUID()
    let name: String
    let amount: Double
    let color: Color
    let icon: String
}
