//
//  HomeViewModel.swift
//  Scene
//
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var selectedSection: HomeSection = .createProject
    @Published var isAccountMenuExpanded = false
    
    func deleteAccount() {
        print("Delete Account tapped")
    }
}
