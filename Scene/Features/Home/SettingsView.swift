//
//  SettingsView.swift
//  Scene
//

import SwiftUI

struct SettingsView: View {
    
    @Binding var isExpanded: Bool
    
    var body: some View {
        
        Button {
            withAnimation(.spring(duration: 0.25)) {
                isExpanded = true
            }
        } label: {
            
            Image(systemName: "gearshape.fill")
                .font(.system(size: 16))
                .foregroundColor(.white)
                .padding()
        }
        .buttonStyle(.plain)
        .glassEffect(in: Circle())
    }
}

// MARK: - Settings Detail View

struct SettingsDetailView: View {
    
    @Binding var isExpanded: Bool
    @AppStorage("userName") private var userName: String = ""
    @State private var tempUserName: String = ""
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            
            // MARK: - Header
            HStack {
                Text("Settings")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                
                Spacer()
                
                Button {
                    withAnimation(.spring(duration: 0.25)) {
                        isExpanded = false
                    }
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.white)
                        .padding(8)
                        .background(.white.opacity(0.1))
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
            }
            
            // MARK: - User Profile Section
            VStack(alignment: .leading, spacing: 16) {
                
                Text("Profile")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Name")
                        .font(.headline)
                        .foregroundStyle(.white.opacity(0.8))
                    
                    TextField("Enter your name", text: $tempUserName)
                        .textFieldStyle(.roundedBorder)
                        .focused($isTextFieldFocused)
                        .onSubmit {
                            saveUserName()
                        }
                        .onChange(of: tempUserName) { oldValue, newValue in
                            // Auto-save as user types (with a small delay)
                            saveUserNameWithDelay()
                        }
                }
            }
            .padding(20)
            .glassEffect(in: RoundedRectangle(cornerRadius: 16))
            
            Spacer()
        }
        .padding(24)
        .onAppear {
            // Load the saved userName when the view appears
            tempUserName = userName
        }
    }
    
    private func saveUserName() {
        userName = tempUserName.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    @State private var saveTask: Task<Void, Never>?
    
    private func saveUserNameWithDelay() {
        // Cancel any existing save task
        saveTask?.cancel()
        
        // Create a new task that waits before saving
        saveTask = Task {
            try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 second delay
            
            if !Task.isCancelled {
                await MainActor.run {
                    saveUserName()
                }
            }
        }
    }
}
