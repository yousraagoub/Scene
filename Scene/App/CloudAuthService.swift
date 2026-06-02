//
//  CloudAuthService.swift
//  Scene
//
//  Created by Raghad Alzemami on 16/12/1447 AH.
//

import CloudKit
import SwiftUI
import Combine

// MARK: - Auth State

enum AuthState {
    case unknown        // not checked yet
    case signedIn       // iCloud account available
    case signedOut      // no iCloud account
    case restricted     // parental controls / managed device
}

// MARK: - Service

@MainActor
final class CloudAuthService: ObservableObject {

    @Published private(set) var authState: AuthState = .unknown
    @Published private(set) var isLoading: Bool = false

    private let container: CKContainer

    init(containerIdentifier: String? = nil) {
        container = containerIdentifier.map(CKContainer.init) ?? .default()
    }

    /// Call once on app launch to check iCloud account status.
    func checkAuth() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let status = try await container.accountStatus()
            switch status {
            case .available:
                authState = .signedIn
            case .noAccount:
                authState = .signedOut
            case .restricted, .temporarilyUnavailable:
                authState = .restricted
            @unknown default:
                authState = .signedOut
            }
        } catch {
            authState = .signedOut
        }
    }

    var isSignedIn: Bool {
        authState == .signedIn
    }
}
