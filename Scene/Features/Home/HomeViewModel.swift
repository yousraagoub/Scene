//
//  HomeViewModel.swift
//  Scene
//
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var selectedSection: HomeSection = .home
    @Published var isAccountMenuExpanded = false
 
    func signOut() {
        print("Sign Out tapped")
    }
    
    func deleteAccount() {
        print("Delete Account tapped")
    }
}
