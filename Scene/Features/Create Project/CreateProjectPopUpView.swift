////
////  CreateProjectModalView.swift
////  Scene
////
//
//import SwiftUI
//import UniformTypeIdentifiers
//import CloudKit
//
//struct CreateProjectPopUpView: View {
//    @EnvironmentObject var settings: AppSettings
//
//    @ObservedObject var homeVM: HomeViewModel
//    @Binding var isExpanded: Bool
//
//    @State private var title = ""
//    @State private var selectedGenre = ""
//    @State private var selectedScriptType: ScriptType = .film
//    @State private var fileURL: URL?
//    @State private var importingFile = false
//    @State private var isAnalyzing = false
//    @State private var errorMessage: String?
//    @State private var analysisStep: AnalysisStep = .idle
//
//    private var genres: [String] {
//        settings.language == .arabic
//        ? [
//            "دراما","أكشن","كوميديا","رعب","إثارة","تشويق",
//            "غموض","جريمة","خيال علمي","فانتازيا","تاريخي","سيرة ذاتية",
//            "رومانسي","مغامرة","حربي","نفسي","وثائقي",
//            "عائلي","موسيقي","رسوم متحركة"
//          ]
//        : [
//            "Drama","Action","Comedy","Horror","Thriller","Suspense",
//            "Mystery","Crime","Sci-Fi","Fantasy","Historical","Biography",
//            "Romance","Adventure","War","Psychological","Documentary",
//            "Family","Musical","Animation"
//          ]
//    }
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 12) {
//
//            // Header
//            HStack {
//                Text("New Project")
//                    .foregroundColor(.white)
//                Spacer()
//                Button { isExpanded = false } label: {
//                    Image(systemName: "xmark")
//                        .foregroundColor(.white)
//                }
//                .buttonStyle(.plain)
//            }
//            .font(.title)
//            Divider()
//            VStack(alignment: .leading, spacing: 16) {
//                // Title
//                HStack {
//                    Text("Title")
//                        .foregroundColor(.white)
//                    TextField("Enter title", text: $title)
//                        .textFieldStyle(.roundedBorder)
//                }
//
//                // Genre
//                Picker("Select Genre", selection: $selectedGenre) {
//                    ForEach(genres, id: \.self) { Text($0) }
//                }
//                .pickerStyle(.menu)
//                .foregroundStyle(.white)
//                .tint(.white)
//
//                // Script type
//                Picker("Production Type", selection: $selectedScriptType) {
//                    ForEach(ScriptType.allCases, id: \.self) { type in
//
//                        Text(
//                            settings.language == .arabic
//                            ? type.arabicName
//                            : type.rawValue
//                        )
//                        .tag(type)
//                    }
//                }
//                .pickerStyle(.segmented)
//                .tint(.white)
//                .controlSize(ControlSize.large)
//            }
//            .padding(.top, 20)
//            .font(.title)
//
//            HStack {
//                Spacer()
//                VStack{
//                    Text("only .docx file")
//                        .font(.title2)
//                        .foregroundColor(.gray)
//                    Button {
//                        withAnimation(.spring(duration: 0.25)) { importingFile = true }
//                    } label: {
//                        Label("Upload Script", systemImage: "plus.circle.fill")
//                            .font(.title2)
//                            .padding()
//                            .foregroundStyle(.black)
//                    }
//                    .buttonStyle(.plain)
//                    .background(.white)
//                    .clipShape(RoundedRectangle(cornerRadius: 50))
//                    .disabled(isAnalyzing)
//                    
//                    
//                    
//                    if let fileURL {
//                        HStack{
//                            Label(fileURL.lastPathComponent, systemImage: "doc.fill")
//                                .font(.system(size: 12))
//                                .foregroundColor(.white)
//                                .lineLimit(1)
//                                .truncationMode(.middle)
//                        }
//                        .padding(6)
//                        .background(Color.white.opacity(0.1))
//                        .clipShape(RoundedRectangle(cornerRadius: 16))
//                    }
//                    
//                    // Analysis step indicator
//                    if isAnalyzing {
//                        HStack(spacing: 8) {
//                            Spacer()
//                            ProgressView()
//                                .progressViewStyle(.circular)
//                                .scaleEffect(0.6)
//                            Text(analysisStep.label)
//                                .font(.system(size: 11))
//                                .foregroundColor(.secondary)
//                            Spacer()
//                        }
//                    }else if let errorMessage {
//                        HStack(spacing: 6) {
//                            Image(systemName: "exclamationmark.triangle.fill")
//                                .foregroundColor(.red)
//                                .font(.headline)
//                            Text(errorMessage)
//                                .font(.title3)
//                                .foregroundColor(.red)
//                                .multilineTextAlignment(.leading)
//                        }
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .padding(8)
//                        .background(Color.red.opacity(0.1))
//                        .clipShape(RoundedRectangle(cornerRadius: 8))
//                    } else {Spacer()}
//                }
//                .padding(.top, 20)
//                    
//                Spacer()
//            }
//            .font(.title)
//
//            HStack {
//                Spacer()
//                Button {
//                    submitProject()
//                } label: {
//                        Text("Submit")
//                            .font(.title2)
//                }
//                .disabled(title.isEmpty || fileURL == nil || isAnalyzing)
//                .padding()
//                .foregroundStyle(.black)
//                .buttonStyle(.plain)
//                .background(title.isEmpty || fileURL == nil ? Color.gray : Color.white)
//                .clipShape(RoundedRectangle(cornerRadius: 50))
//                Spacer()
//
//            }
//        }
//        .onAppear {
//            if selectedGenre.isEmpty {
//                selectedGenre = settings.language == .arabic ? "دراما" : "Drama"
//            }
//        }
//        .padding(20)
//        .frame(width: 520, height: 540, alignment: .topLeading)
//        .glassEffect(in: RoundedRectangle(cornerRadius: 30))
//        .fileImporter(
//            isPresented: $importingFile,
//            allowedContentTypes: [UTType(filenameExtension: "docx") ?? .data]
//        ) { result in
//            switch result {
//            case .success(let url): fileURL = url
//            case .failure(let error): errorMessage = "Could not open file: \(error.localizedDescription)"
//            }
//        }
//    }
//    
//
//    // MARK: - Submit
//
//    private func submitProject() {
//        guard let fileURL else { return }
//
//        isAnalyzing  = true
//        errorMessage = nil
//
//        Task {
//            do {
//                // Step 1: Extract text from .docx
//                setStep(.extracting)
//                let text = try extractText(from: fileURL)
//
//                // Step 2: Save project to CloudKit as .analyzing
//                setStep(.savingProject)
//                let cloudService = CloudStorageService()
//
//                // Check iCloud availability before saving
//                try await checkiCloudAvailability()
//
//                var project = ProjectModel(
//                    id:         UUID().uuidString,
//                    title:      title,
//                    genre:      selectedGenre,
//                    scriptType: selectedScriptType,
//                    status:     .analyzing,
//                    createdAt:  Date(),
//                    fileURL:    fileURL
//                )
//                try await cloudService.saveProject(project)
//
//                // Step 3: Analyze with AI
//                setStep(.analyzing)
//                let aiBreakdown = try await AIService(ApiKey: Secrets.openAIKey)
//                    .analyze(screenplayText: text)
//                let breakdown = aiBreakdown.toScriptBreakdown()
//
//                guard !breakdown.scenes.isEmpty else {
//                    throw ProjectSubmissionError.emptyBreakdown
//                }
//
//                // Step 4: Save breakdown + mark ready
//                setStep(.saving)
//                try await cloudService.saveBreakdown(breakdown, for: project.id)
//                project.status = .ready
//                try await cloudService.saveProject(project)
//
//                await MainActor.run {
//                    homeVM.projects.append(project)
//                    homeVM.selectedProject = project
//                    homeVM.selectedSection = .breakdown
//                    isAnalyzing   = false
//                    analysisStep  = .idle
//                    isExpanded    = false
//                }
//
//            } catch {
//                await MainActor.run {
//                    errorMessage = friendlyMessage(for: error)
//                    isAnalyzing  = false
//                    analysisStep = .idle
//                }
//            }
//        }
//    }
//
//    // MARK: - Helpers
//
//    private func setStep(_ step: AnalysisStep) {
//        Task { @MainActor in analysisStep = step }
//    }
//
//    private func extractText(from url: URL) throws -> String {
//        let tempURL = FileManager.default.temporaryDirectory
//            .appendingPathComponent(UUID().uuidString + ".docx")
//
//        let accessed = url.startAccessingSecurityScopedResource()
//        defer { if accessed { url.stopAccessingSecurityScopedResource() } }
//
//        guard accessed else { throw ProjectSubmissionError.fileAccessDenied }
//
//        try FileManager.default.copyItem(at: url, to: tempURL)
//        defer { try? FileManager.default.removeItem(at: tempURL) }
//
//        let raw = try ExtractText.extractText(from: tempURL)
//        let cleaned = raw
//            .replacingOccurrences(of: "\n\n\n", with: "\n\n")
//            .trimmingCharacters(in: .whitespacesAndNewlines)
//
//        guard !cleaned.isEmpty else { throw DocumentReaderError.emptyDocument }
//        return cleaned
//    }
//
//    private func checkiCloudAvailability() async throws {
//        let status = try await CKContainer.default().accountStatus()
//        switch status {
//        case .available: return
//        case .noAccount:    throw ProjectSubmissionError.iCloudNotSignedIn
//        case .restricted:   throw ProjectSubmissionError.iCloudRestricted
//        case .temporarilyUnavailable: throw ProjectSubmissionError.iCloudUnavailable
//        default:            throw ProjectSubmissionError.iCloudUnavailable
//        }
//    }
//
//    // MARK: - User-friendly error messages
//
//    private func friendlyMessage(for error: Error) -> String {
//        // Document errors
//        if let e = error as? DocumentReaderError {
//            switch e {
//            case .cannotDecodeXML: return "Could not read the file. Make sure it's a valid .docx exported from Word or Final Draft."
//            case .emptyDocument:   return "The document appears to be empty. Please check the file and try again."
//            }
//        }
//
//        // AI errors
//        if let e = error as? ScreenplayAnalyzerError {
//            switch e {
//            case .noContent:          return "The AI returned an empty response. Please try again."
//            case .invalidJSON(let d): return "Could not parse the AI response. Try again. (\(d))"
//            case .apiError(let d):
//                if d.contains("401") || d.contains("invalid_api_key") {
//                    return "Invalid OpenAI API key. Please check your key in Secrets."
//                } else if d.contains("429") || d.contains("rate_limit") {
//                    return "OpenAI rate limit reached. Please wait a moment and try again."
//                } else if d.contains("insufficient_quota") {
//                    return "OpenAI quota exceeded. Please check your OpenAI billing."
//                }
//                return "AI service error. Please try again."
//            }
//        }
//
//        // Custom submission errors
//        if let e = error as? ProjectSubmissionError {
//            switch e {
//            case .fileAccessDenied:  return "Could not access the file. Please select it again."
//            case .emptyBreakdown:    return "The AI could not find any scenes in this screenplay. Make sure the file is a properly formatted screenplay."
//            case .iCloudNotSignedIn: return "You're not signed into iCloud. Please sign in via System Settings → Apple Account."
//            case .iCloudRestricted:  return "iCloud access is restricted on this device."
//            case .iCloudUnavailable: return "iCloud is temporarily unavailable. Please try again in a moment."
//            }
//        }
//
//        // CloudKit errors
//        if let ckError = error as? CKError {
//            switch ckError.code {
//            case .networkUnavailable, .networkFailure:
//                return "No internet connection. Please check your network and try again."
//            case .notAuthenticated:
//                return "iCloud authentication failed. Please sign in to iCloud and try again."
//            case .quotaExceeded:
//                return "iCloud storage is full. Please free up space and try again."
//            case .serviceUnavailable:
//                return "iCloud is currently unavailable. Please try again later."
//            case .requestRateLimited:
//                return "Too many requests to iCloud. Please wait a moment and try again."
//            default:
//                return "iCloud error (\(ckError.code.rawValue)). Please try again."
//            }
//        }
//
//        // Network errors
//        if let urlError = error as? URLError {
//            switch urlError.code {
//            case .notConnectedToInternet:
//                return "No internet connection. Please check your network."
//            case .timedOut:
//                return "The request timed out. Please try again."
//            case .cancelled:
//                return "The request was cancelled."
//            default:
//                return "Network error. Please check your connection and try again."
//            }
//        }
//
//        // Fallback
//        return "Something went wrong: \(error.localizedDescription)"
//    }
//}
// 
//
//
//// MARK: - Analysis Step
//
//private enum AnalysisStep {
//    case idle, extracting, savingProject, analyzing, saving
//
//    var label: String {
//        switch self {
//        case .idle:          return ""
//        case .extracting:    return "Reading screenplay…"
//        case .savingProject: return "Creating project…"
//        case .analyzing:     return "Analyzing, this may take a minute…"
//        case .saving:        return "Saving breakdown…"
//        }
//    }
//}
//
//// MARK: - Submission Errors
//
//private enum ProjectSubmissionError: LocalizedError {
//    case fileAccessDenied
//    case emptyBreakdown
//    case iCloudNotSignedIn
//    case iCloudRestricted
//    case iCloudUnavailable
//
//    var errorDescription: String? {
//        switch self {
//        case .fileAccessDenied:  return "File access denied."
//        case .emptyBreakdown:    return "No scenes found in screenplay."
//        case .iCloudNotSignedIn: return "Not signed into iCloud."
//        case .iCloudRestricted:  return "iCloud access restricted."
//        case .iCloudUnavailable: return "iCloud unavailable."
//        }
//    }
//}

import SwiftUI
import UniformTypeIdentifiers
import CloudKit

struct CreateProjectPopUpView: View {
    @EnvironmentObject var settings: AppSettings

    @ObservedObject var homeVM: HomeViewModel
    @Binding var isExpanded: Bool

    @State private var title = ""
    @State private var selectedGenre = ""
    @State private var selectedScriptType: ScriptType = .film
    @State private var fileURL: URL?
    @State private var importingFile = false
    @State private var isAnalyzing = false
    @State private var errorMessage: String?
    @State private var analysisStep: AnalysisStep = .idle

    private var genres: [String] {
        settings.language == .arabic
        ? [
            "دراما","أكشن","كوميديا","رعب","إثارة","تشويق",
            "غموض","جريمة","خيال علمي","فانتازيا","تاريخي","سيرة ذاتية",
            "رومانسي","مغامرة","حربي","نفسي","وثائقي",
            "عائلي","موسيقي","رسوم متحركة"
          ]
        : [
            "Drama","Action","Comedy","Horror","Thriller","Suspense",
            "Mystery","Crime","Sci-Fi","Fantasy","Historical","Biography",
            "Romance","Adventure","War","Psychological","Documentary",
            "Family","Musical","Animation"
          ]
    }
    var body: some View {
        let isArabic = settings.language == .arabic
        ZStack(alignment: isArabic ? .bottomTrailing : .bottomLeading) {
       // ZStack(alignment: isArabic ? .bottomLeading : .bottomTrailing) {

            VStack(alignment: .leading, spacing: 0) {

                HStack {
                    Text(isArabic ? "ملف جديد" : "New Project")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                    Button { isExpanded = false } label: {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.bottom, 24)

                HStack(spacing: 16) {
                    Text(isArabic ? "العنوان" : "Title")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .fixedSize()

                    TextField(isArabic ? "ادخل العنوان" : "Enter title", text: $title)
                        .textFieldStyle(.plain)
                        .font(.title2)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .glassEffect(in: RoundedRectangle(cornerRadius: 50))
                }
                .padding(.bottom, 20)

                HStack(alignment: .top, spacing: 20) {

                    // Left: Genre dropdown
                    VStack(alignment: .leading, spacing: 10) {
                        Text(isArabic ? "التصنيف" : "Category")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)

                        Picker("", selection: $selectedGenre) {
                            ForEach(genres, id: \.self) { Text($0).tag($0) }
                        }
                        .pickerStyle(.menu)
                        .tint(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .glassEffect(in: RoundedRectangle(cornerRadius: 50))
                        .frame(minWidth: 160)
                    }

                    // Right: Production type segmented picker
                    VStack(alignment: .leading, spacing: 10) {
                        Text(isArabic ? "نوع الإنتاج" : "Production Type")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        HStack(spacing: 0) {
                            ForEach(ScriptType.allCases, id: \.self) { type in
                                let isSelected = selectedScriptType == type
                                Button {
                                    withAnimation(.spring(duration: 0.2)) {
                                        selectedScriptType = type
                                    }
                                } label: {
                                    Text(isArabic ? type.arabicName : type.rawValue)
                                        .font(.title3)
                                        .fontWeight(isSelected ? .semibold : .regular)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 10)
                                        .background {
                                            if isSelected {
                                                RoundedRectangle(cornerRadius: 50)
                                                    .fill(.ultraThinMaterial)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 50)
                                                            .stroke(Color.white.opacity(0.35), lineWidth: 1)
                                                    )
                                            }
                                        }
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(4)
                        .frame(maxWidth: .infinity)
                        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 50))
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.bottom, 20)

                VStack(alignment: isArabic ? .trailing : .leading, spacing: 10) {
               // VStack(alignment: isArabic ? .leading : .trailing, spacing: 10) {

                    // Upload button — left in English, right in Arabic
                    Button {
                        withAnimation(.spring(duration: 0.25)) { importingFile = true }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.black)
                            Text(isArabic ? "إرفاق النص" : "Upload Script")
                                .font(.title2)
                                .fontWeight(.medium)
                                .foregroundColor(.black)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                    }
                    .buttonStyle(.plain)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 50))
                    .disabled(isAnalyzing)

                    // Attached file name
                    if let fileURL {
                        HStack(spacing: 6) {
                            Label(fileURL.lastPathComponent, systemImage: "doc.fill")
                                .font(.system(size: 13))
                                .foregroundColor(.white)
                                .lineLimit(1)
                                .truncationMode(.middle)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.white.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 50))
                    }

                    // .docx only hint
                    Text(isArabic ? "يرجى رفع الملف بصيغة .docx فقط." : "Only .docx files are accepted.")
                        .font(.callout)
                        .foregroundColor(.gray)

                    // Analysis progress
                    if isAnalyzing {
                        HStack(spacing: 8) {
                            ProgressView()
                                .progressViewStyle(.circular)
                                .scaleEffect(0.7)
                            Text(analysisStep.label)
                                .font(.callout)
                                .foregroundColor(.secondary)
                        }
                    } else if let errorMessage {
                        HStack(spacing: 6) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.red)
                            Text(errorMessage)
                                .font(.callout)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.leading)
                        }
                        .padding(8)
                        .background(Color.red.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 50))
                    }
                }
                //.frame(maxWidth: .infinity, alignment: isArabic ? .trailing : .leading)
                .frame(maxWidth: .infinity, alignment: isArabic ? .leading : .trailing)

                Spacer()
            }
            .padding(28)

            // Submit checkmark button
            let scriptUploaded = fileURL != nil && !isAnalyzing
            let canSubmit = !title.isEmpty && scriptUploaded
            Button {
                submitProject()
            } label: {
                Image(systemName: "checkmark")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(scriptUploaded ? .white : .white.opacity(0.4))
                    .frame(width: 52, height: 52)
                    .background(
                        Group {
                            if scriptUploaded {
                                Circle()
                                    .fill(.ultraThinMaterial)
                                    .overlay(Circle().stroke(Color.white.opacity(0.4), lineWidth: 1))
                            } else {
                                Circle().fill(Color.white.opacity(0.15))
                            }
                        }
                    )
            }
            .buttonStyle(.plain)
            .disabled(!canSubmit)
            .padding(28)
        }
        .onAppear {
            if selectedGenre.isEmpty {
                selectedGenre = isArabic ? "دراما" : "Drama"
            }
        }
        .environment(\.layoutDirection, isArabic ? .rightToLeft : .leftToRight)
        .frame(width: 520, height: 480, alignment: .topLeading)
        .glassEffect(in: RoundedRectangle(cornerRadius: 50))
        .fileImporter(
            isPresented: $importingFile,
            allowedContentTypes: [UTType(filenameExtension: "docx") ?? .data]
        ) { result in
            switch result {
            case .success(let url): fileURL = url
            case .failure(let error): errorMessage = "Could not open file: \(error.localizedDescription)"
            }
        }
    }


    // MARK: - Submit

    private func submitProject() {
        guard let fileURL else { return }

        isAnalyzing  = true
        errorMessage = nil

        Task {
            do {
                setStep(.extracting)
                let text = try extractText(from: fileURL)

                setStep(.savingProject)
                let cloudService = CloudStorageService()
                try await checkiCloudAvailability()

                var project = ProjectModel(
                    id:         UUID().uuidString,
                    title:      title,
                    genre:      selectedGenre,
                    scriptType: selectedScriptType,
                    status:     .analyzing,
                    createdAt:  Date(),
                    fileURL:    fileURL
                )
                try await cloudService.saveProject(project)

                setStep(.analyzing)
                let aiBreakdown = try await AIService(ApiKey: Secrets.openAIKey)
                    .analyze(screenplayText: text)
                let breakdown = aiBreakdown.toScriptBreakdown()

                guard !breakdown.scenes.isEmpty else {
                    throw ProjectSubmissionError.emptyBreakdown
                }

                setStep(.saving)
                try await cloudService.saveBreakdown(breakdown, for: project.id)
                project.status = .ready
                try await cloudService.saveProject(project)

                await MainActor.run {
                    homeVM.projects.append(project)
                    homeVM.selectedProject = project
                    homeVM.selectedSection = .breakdown
                    isAnalyzing   = false
                    analysisStep  = .idle
                    isExpanded    = false
                }

            } catch {
                await MainActor.run {
                    errorMessage = friendlyMessage(for: error)
                    isAnalyzing  = false
                    analysisStep = .idle
                }
            }
        }
    }

    private func setStep(_ step: AnalysisStep) {
        Task { @MainActor in analysisStep = step }
    }

    private func extractText(from url: URL) throws -> String {
        let tempURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString + ".docx")

        let accessed = url.startAccessingSecurityScopedResource()
        defer { if accessed { url.stopAccessingSecurityScopedResource() } }

        guard accessed else { throw ProjectSubmissionError.fileAccessDenied }

        try FileManager.default.copyItem(at: url, to: tempURL)
        defer { try? FileManager.default.removeItem(at: tempURL) }

        let raw = try ExtractText.extractText(from: tempURL)
        let cleaned = raw
            .replacingOccurrences(of: "\n\n\n", with: "\n\n")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard !cleaned.isEmpty else { throw DocumentReaderError.emptyDocument }
        return cleaned
    }

    private func checkiCloudAvailability() async throws {
        let status = try await CKContainer.default().accountStatus()
        switch status {
        case .available: return
        case .noAccount:    throw ProjectSubmissionError.iCloudNotSignedIn
        case .restricted:   throw ProjectSubmissionError.iCloudRestricted
        case .temporarilyUnavailable: throw ProjectSubmissionError.iCloudUnavailable
        default:            throw ProjectSubmissionError.iCloudUnavailable
        }
    }

    private func friendlyMessage(for error: Error) -> String {
        if let e = error as? DocumentReaderError {
            switch e {
            case .cannotDecodeXML: return "Could not read the file. Make sure it's a valid .docx exported from Word or Final Draft."
            case .emptyDocument:   return "The document appears to be empty. Please check the file and try again."
            }
        }
        if let e = error as? ScreenplayAnalyzerError {
            switch e {
            case .noContent:          return "The AI returned an empty response. Please try again."
            case .invalidJSON(let d): return "Could not parse the AI response. Try again. (\(d))"
            case .apiError(let d):
                if d.contains("401") || d.contains("invalid_api_key") {
                    return "Invalid OpenAI API key. Please check your key in Secrets."
                } else if d.contains("429") || d.contains("rate_limit") {
                    return "OpenAI rate limit reached. Please wait a moment and try again."
                } else if d.contains("insufficient_quota") {
                    return "OpenAI quota exceeded. Please check your OpenAI billing."
                }
                return "AI service error. Please try again."
            }
        }
        if let e = error as? ProjectSubmissionError {
            switch e {
            case .fileAccessDenied:  return "Could not access the file. Please select it again."
            case .emptyBreakdown:    return "The AI could not find any scenes in this screenplay. Make sure the file is a properly formatted screenplay."
            case .iCloudNotSignedIn: return "You're not signed into iCloud. Please sign in via System Settings → Apple Account."
            case .iCloudRestricted:  return "iCloud access is restricted on this device."
            case .iCloudUnavailable: return "iCloud is temporarily unavailable. Please try again in a moment."
            }
        }
        if let ckError = error as? CKError {
            switch ckError.code {
            case .networkUnavailable, .networkFailure:
                return "No internet connection. Please check your network and try again."
            case .notAuthenticated:
                return "iCloud authentication failed. Please sign in to iCloud and try again."
            case .quotaExceeded:
                return "iCloud storage is full. Please free up space and try again."
            case .serviceUnavailable:
                return "iCloud is currently unavailable. Please try again later."
            case .requestRateLimited:
                return "Too many requests to iCloud. Please wait a moment and try again."
            default:
                return "iCloud error (\(ckError.code.rawValue)). Please try again."
            }
        }
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet: return "No internet connection. Please check your network."
            case .timedOut:               return "The request timed out. Please try again."
            case .cancelled:              return "The request was cancelled."
            default:                      return "Network error. Please check your connection and try again."
            }
        }
        return "Something went wrong: \(error.localizedDescription)"
    }
}
private enum AnalysisStep {
    case idle, extracting, savingProject, analyzing, saving

    var label: String {
        switch self {
        case .idle:          return ""
        case .extracting:    return "Reading screenplay…"
        case .savingProject: return "Creating project…"
        case .analyzing:     return "Analyzing, this may take a minute…"
        case .saving:        return "Saving breakdown…"
        }
    }
}

// MARK: - Submission Errors

private enum ProjectSubmissionError: LocalizedError {
    case fileAccessDenied
    case emptyBreakdown
    case iCloudNotSignedIn
    case iCloudRestricted
    case iCloudUnavailable

    var errorDescription: String? {
        switch self {
        case .fileAccessDenied:  return "File access denied."
        case .emptyBreakdown:    return "No scenes found in screenplay."
        case .iCloudNotSignedIn: return "Not signed into iCloud."
        case .iCloudRestricted:  return "iCloud access restricted."
        case .iCloudUnavailable: return "iCloud unavailable."
        }
    }
}
