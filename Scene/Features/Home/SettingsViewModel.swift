//
//  SettingsViewModel.swift
//  Scene
//

import SwiftUI

struct SettingsViewModel: View {

    @EnvironmentObject var settings: AppSettings
    @Binding var isExpanded: Bool
    @AppStorage("userName") private var userName: String = ""
    @State private var tempUserName: String = ""
    @FocusState private var isNameFieldFocused: Bool

    var body: some View {

        VStack(alignment: .leading, spacing: 12) {
            HStack{
                Text("Settings")
                    .font(.title)
                Spacer()
                Button {
                    isExpanded = false
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28, height: 28)
                }
                .buttonStyle(.plain)

            }
            Divider()
            HStack(spacing: 10) {
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
                
                Text("Name")
                    .font(.title)
                TextField("Name", text: $tempUserName)
                    .font(.title)
                    .focused($isNameFieldFocused)
                    .onSubmit {
                        saveUserName()
                    }
                    .onChange(of: tempUserName) { oldValue, newValue in
                        saveUserNameWithDelay()
                    }
                Image(systemName: "square.and.pencil")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
                    
            }
            .padding(.top, 20)
            .foregroundStyle(.white)
            Picker("Language", selection: $settings.language) {

                Text("English").tag(AppLanguage.english)
                Text("Arabic").tag(AppLanguage.arabic)
            }
            .controlSize(ControlSize.large)
            .font(.title)
            .pickerStyle(.segmented)
            .tint(.white)
            .padding(.top, 20)
            Spacer()

        }
        .padding(20)
        .frame(width: 519, height: 250, alignment: .topLeading)
        .glassEffect(in: RoundedRectangle(cornerRadius: 30))
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
