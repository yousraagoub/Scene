//
//  CreateProjectModalView.swift
//  Scene
//

import SwiftUI
import UniformTypeIdentifiers

struct CreateProjectPopUpView: View {

    @ObservedObject var homeVM: HomeViewModel

    @Binding var isExpanded: Bool

    @State private var title = ""
    @State private var selectedGenre = "Drama"
    @State private var selectedScriptType: ScriptType = .film
    @State private var fileURL: URL?
    @State private var importingFile = false

    // ADDED: tracks loading state while AI is working
    @State private var isAnalyzing = false

    // ADDED: surfaces any error to the UI
    @State private var errorMessage: String? = nil

    let genres = [ "Drama","Action","Comedy","Horror","Thriller","Suspense","Mystery","Crime","Sci-Fi","Fantasy","Historical","Biography","Romance", "Adventure","War","Psychological","Documentary","Family","Musical","Animation"
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack{
                Text("New Project")
                    .font(.title)
                    .foregroundColor(.white)
                Spacer()
                Button {
                    isExpanded = false
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16)
                        .foregroundColor(.white)
                }
                .buttonStyle(.plain)
            }
            Divider()

            HStack {
                Text("Title")
                    .font(.title2)
                    .foregroundColor(.white)
                TextField("Enter title", text: $title)
                    .font(.title2)
                    .textFieldStyle(.roundedBorder)
            }

            HStack{
                Picker("Select Genre", selection: $selectedGenre) {
                    ForEach(genres, id: \.self) { genre in
                        Text(genre)
                            .font(.title2)
                    }
                }
                .font(.title2)
                .pickerStyle(.menu)
                .foregroundStyle(.white)
                .tint(.white)
            }

            HStack {
                Text("Production Type")
                    .font(.title2)
                    .foregroundStyle(.white)
                HStack(spacing: 0) {
                    
                    ForEach(ScriptType.allCases, id: \.self) { type in
                        Button {
                            selectedScriptType = type
                        } label: {
                            Text(type.rawValue)
                                .font(.title2)
                                .frame(width: 70 ,alignment: .center)
                                .fixedSize(horizontal: true, vertical: true)
                        }
                        .buttonStyle(.plain)
                        .background(selectedScriptType == type ? Color.white : Color.clear)
                        .foregroundStyle(selectedScriptType == type ? .black : .white )
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(.white.opacity(0.3)))
                
            }
           

            HStack{
                Spacer()
                if let fileURL {
                    Text(fileURL.lastPathComponent)
                        .foregroundColor(.green)
                }
                Spacer()
            }

            HStack{
                Spacer()
                Button {
                    withAnimation(.spring(duration: 0.25)) {
                        importingFile = true
                    }
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16)
                        .foregroundStyle(.black)
                    Text("Upload Script")
                        .font(.title2)
                        .foregroundStyle(.black)
                }
                .padding()
                .buttonStyle(.plain)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 50))
                Spacer()
            }

            HStack{
                Spacer()
                Text("Choose .docx Files")
                    .font(.body)
                    .foregroundColor(.secondary)
                Spacer()
            }

//            Spacer()

            // ADDED: shows error message if something goes wrong
            if let errorMessage {
                Text(errorMessage)
                    .font(.system(size: 11))
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
            }

            HStack {
                Spacer()

                Button {
                    // ADDED: replaced dummy data with real AI pipeline
                    submitProject()
                } label: {
                    // ADDED: spinner while AI is working, text otherwise
                    if isAnalyzing {
                        HStack(spacing: 8) {
                            Text(isAnalyzing ? "LOADING..." : "Create")
                        }
                            
                    } else {
                        Text("Create")
                            
                    }
                }
                // ADDED: disabled until title + file are ready, or while loading
                .disabled(title.isEmpty || fileURL == nil || isAnalyzing)
                .font(.title2)
                .foregroundStyle(.black)
                .padding()
                .fixedSize(horizontal: true, vertical: false)
                .foregroundStyle(.black)
                .buttonStyle(.plain)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 30))
            }
        }
        .padding()
        .frame(width: 519, alignment: .topLeading)
        .fixedSize(horizontal: false, vertical: true)
        .glassEffect(in: RoundedRectangle(cornerRadius: 30))
        
        // CHANGED: allowedContentTypes now includes .docx
        .fileImporter(
            isPresented: $importingFile,
            allowedContentTypes: [
                .plainText,
                UTType(filenameExtension: "docx") ?? .data
            ]
        ) { result in
            switch result {
            case .success(let url):
                fileURL = url
            case .failure:
                break
            }
        }
    }

    // ADDED: the real submit function —
    // reads the .docx via ZIPFoundation, sends text to GPT-4o,
    // builds the project from the real breakdown
    private func submitProject() {
        guard let fileURL else { return }

        isAnalyzing  = true
        errorMessage = nil

        Task {
            do {
                // 1. Copy to a temp location so we can safely unzip it
                let tempURL = FileManager.default.temporaryDirectory
                    .appendingPathComponent(UUID().uuidString + ".docx")

                let accessed = fileURL.startAccessingSecurityScopedResource()
                defer { if accessed { fileURL.stopAccessingSecurityScopedResource() } }

                try FileManager.default.copyItem(at: fileURL, to: tempURL)
                defer { try? FileManager.default.removeItem(at: tempURL) }

                // 2. Extract plain text from the .docx using ZIPFoundation
                let rawText = try ExtractText.extractText(from: tempURL)
                let cleaned = rawText
                    .replacingOccurrences(of: "\n\n\n", with: "\n\n")
                    .trimmingCharacters(in: .whitespacesAndNewlines)

                // 3. Send to GPT-4o and get back a ScreenplayBreakdown
                let service  = AIService(ApiKey: Secrets.openAIKey)
                let breakdown = try await service.analyze(screenplayText: cleaned).toScriptBreakdown()

                // 4. Build the project — same as before, just with real breakdown
                let project = ProjectModel(
                    title: title,
                    genre: selectedGenre,
                    scriptType: selectedScriptType,
                    fileURL: fileURL,
                    breakdown: breakdown
                )

                await MainActor.run {
                    homeVM.projects.append(project)
                    homeVM.selectedProject  = project
                    homeVM.selectedSection  = .breakdown
                    isAnalyzing = false
                    isExpanded  = false
                }

            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    isAnalyzing  = false
                }
            }
        }
    }
}
