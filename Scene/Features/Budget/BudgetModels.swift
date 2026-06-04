//
//  BudgetModels.swift
//  Scene
//
import Foundation

struct BudgetItem: Identifiable {

    let id = UUID()

    let name: String

    var amount: Double
}

