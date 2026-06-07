//
//  CreateProjectModalView.swift
//  Scene
//

//import SwiftUI
//import UniformTypeIdentifiers
//
//struct CreateProjectPopUpView: View {
//
//    @ObservedObject var homeVM: HomeViewModel
//
//    @Binding var isExpanded: Bool
//
//    @State private var title = ""
//
//    @State private var selectedGenre = "Drama"
//
//    @State private var selectedScriptType: ScriptType = .film
//
//    @State private var fileURL: URL?
//
//    @State private var importingFile = false
//
//    let genres = [ "Drama","Action","Comedy","Horror","Thriller","Suspense","Mystery","Crime","Sci-Fi","Fantasy","Historical","Biography","Romance", "Adventure","War","Psychological","Documentary","Family","Musical","Animation"
//    ]
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 18) {
//            HStack{
//                Text("New Project")
//                    .font(.title.bold())
//                    .foregroundColor(.white)
//                Spacer()
//                Button {
//                    isExpanded = false
//                } label: {
//                    Image(systemName: "xmark")
//                        .font(.system(size: 16, weight: .semibold))
//                        .foregroundColor(.white)
//                }
//                .buttonStyle(.plain)
//            }
//            HStack {
//
//                Text("Title")
//                    .foregroundColor(.white)
//
//                TextField(
//                    "Enter title",
//                    text: $title
//                )
//                .textFieldStyle(.roundedBorder)
//            }
//
//            HStack{
//                Picker("Select Genre", selection: $selectedGenre) {
//                    ForEach(genres, id: \.self) { genre in
//                        Text(genre)
//                    }
//                }
//                .pickerStyle(.menu)
//                .foregroundStyle(.white)
//                .tint(.white)
//            }
//            HStack {
//
//                Picker(
//                    "Production Type",
//                    selection: $selectedScriptType
//                ) {
//
//                    ForEach(
//                        ScriptType.allCases,
//                        id: \.self
//                    ) {
//                        Text($0.rawValue)
//                    }
//                }
//                .pickerStyle(.segmented)
//                .tint(.white)
//            }
//
//            
//            HStack{
//                Spacer()
//                if let fileURL {
//
//                    Text(fileURL.lastPathComponent)
//                        .foregroundColor(.green)
//                }
//                Spacer()
//            }
//            
//
//            HStack{
//                Spacer()
//                Button {
//
//                    withAnimation(.spring(duration: 0.25)) {
//                        importingFile = true
//                    }
//
//                } label: {
//
//                    Label("Upload Script",
//                          systemImage: "plus.circle.fill")
//                        .font(.system(size: 12))
//                        .padding()
//                        .frame(maxWidth: 160, maxHeight: 36)
//                        .foregroundStyle(.black)
//                }
//                .buttonStyle(.plain)
//                .background(.white)
//                .clipShape(RoundedRectangle(cornerRadius: 50))
//                Spacer()
//            }
//            
//            
//            
//            HStack{
//                Spacer()
//                Text("Choose .docx / .txt Files")
//                    .font(.system(size: 12))
//                    .foregroundColor(.gray)
//                Spacer()
//            }
//
//            Spacer()
//
//            HStack {
//
//                Spacer()
//
//                Button("Submit") {
//                    //MARK: - Dummy Data:
//                    let scene1 = SceneBreakdown(
//                        number: 1,
//                        title: "Coffee Shop",
//                        characters: [
//                            CharacterBreakdown(
//                                name: "John",
//                                role: "Lead"
//                            )
//                        ],
//                        locations: [
//                            LocationBreakdown(
//                                name: "Coffee Shop",
//                                type: "Interior"
//                            )
//                        ],
//                        props: [
//                            PropBreakdown(
//                                name: "Notebook"
//                            )
//                        ],
//                        visualEffects: [
//                            "Rain"
//                        ]
//                    )
//
//                    let scene2 = SceneBreakdown(
//                        number: 2,
//                        title: "Street",
//                        characters: [
//                            CharacterBreakdown(
//                                name: "Sarah",
//                                role: "Support"
//                            )
//                        ],
//                        locations: [
//                            LocationBreakdown(
//                                name: "Street",
//                                type: "Exterior"
//                            )
//                        ],
//                        props: [
//                            PropBreakdown(
//                                name: "Phone"
//                            )
//                        ],
//                        visualEffects: [
//                            "Explosion"
//                        ]
//                    )
//
//                    let breakdown = ScriptBreakdown(
//                        scenes: [
//                            scene1,
//                            scene2
//                        ],
//                        totalCharacters: [
//                            CharacterBreakdown(
//                                name: "John",
//                                role: "Lead"
//                            ),
//                            CharacterBreakdown(
//                                name: "Sarah",
//                                role: "Support"
//                            )
//                        ],
//                        totalLocations: [
//                            LocationBreakdown(
//                                name: "Coffee Shop",
//                                type: "Interior"
//                            ),
//                            LocationBreakdown(
//                                name: "Street",
//                                type: "Exterior"
//                            )
//                        ],
//                        totalProps: [
//                            PropBreakdown(name: "Notebook"),
//                            PropBreakdown(name: "Phone")
//                        ],
//                        totalVisualEffects: [
//                            "Rain",
//                            "Explosion"
//                        ]
//                    )
//                    let project = ProjectModel(
//                        title: title,
//                        genre: selectedGenre,
//                        scriptType: selectedScriptType,
//                        fileURL: fileURL,
//                        breakdown: breakdown
//                    )
//
//                    homeVM.projects.append(project)
//
//                    homeVM.selectedProject = project
//
//                    homeVM.selectedSection = .breakdown
//
//                    isExpanded = false
//                }
//                .font(.system(size: 12))
//                .padding()
//                .frame(maxWidth: 90, maxHeight: 36)
//                .foregroundStyle(.black)
//                .buttonStyle(.plain)
//                .background(.white)
//                .clipShape(RoundedRectangle(cornerRadius: 20))
//            }
//        }
//        .padding(20)
//        .frame(width: 519, height: 402, alignment: .topLeading)
//        .glassEffect(in: RoundedRectangle(cornerRadius: 30))
//        .fileImporter(
//            isPresented: $importingFile,
//            allowedContentTypes: [
//                .plainText,
//                .data
//            ]
//        ) { result in
//
//            switch result {
//
//            case .success(let url):
//                fileURL = url
//
//            case .failure:
//                break
//            }
//        }
//    }
//}
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
                    .font(.title.bold())
                    .foregroundColor(.white)
                Spacer()
                Button {
                    isExpanded = false
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                }
                .buttonStyle(.plain)
            }

            HStack {
                Text("Title")
                    .foregroundColor(.white)
                TextField("Enter title", text: $title)
                    .textFieldStyle(.roundedBorder)
            }

            HStack{
                Picker("Select Genre", selection: $selectedGenre) {
                    ForEach(genres, id: \.self) { genre in
                        Text(genre)
                    }
                }
                .pickerStyle(.menu)
                .foregroundStyle(.white)
                .tint(.white)
            }

            HStack {
                Picker("Production Type", selection: $selectedScriptType) {
                    ForEach(ScriptType.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                .tint(.white)
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
                    Label("Upload Script", systemImage: "plus.circle.fill")
                        .font(.system(size: 12))
                        .padding()
                        .frame(maxWidth: 160, maxHeight: 36)
                        .foregroundStyle(.black)
                }
                .buttonStyle(.plain)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 50))
                Spacer()
            }

            HStack{
                Spacer()
                Text("Choose .docx / .txt Files")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                Spacer()
            }

            Spacer()

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
                        ProgressView()
                            .progressViewStyle(.circular)
                            .scaleEffect(0.7)
                    } else {
                        Text("Submit")
                    }
                }
                // ADDED: disabled until title + file are ready, or while loading
                .disabled(title.isEmpty || fileURL == nil || isAnalyzing)
                .font(.system(size: 12))
                .padding()
                .frame(maxWidth: 90, maxHeight: 36)
                .foregroundStyle(.black)
                .buttonStyle(.plain)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }
        .padding(20)
        .frame(width: 519, height: 402, alignment: .topLeading)
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
