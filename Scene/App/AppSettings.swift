//
//  AppSettings.swift
//  Scene
//
import SwiftUI
import Combine

@MainActor
final class AppSettings: ObservableObject {
    
    @Published var language: AppLanguage = .english
    
    var layoutDirection: LayoutDirection {
        language == .arabic ? .rightToLeft : .leftToRight
    }
    
    var locale: Locale {
        Locale(identifier: language.code)
    }
}

enum AppLanguage {
    case english
    case arabic
    
    var code: String {
        switch self {
        case .english:
            return "en"
        case .arabic:
            return "ar"
        }
    }
}
