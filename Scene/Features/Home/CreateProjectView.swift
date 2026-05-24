//
//  HomeLandingView.swift
//  Scene
//


import SwiftUI
import UniformTypeIdentifiers

struct CreateProjectView: View {

    @State private var showImporter = false
    @State private var isAnalyzing  = false
    @State private var errorMessage: String?
    @State private var breakdown: ScreenplayBreakdown?

    private let apiKey = "YOUR_API_KEY"

    var body: some View {
        Button {
            showImporter = true
        } label: {
            HStack(spacing: 8) {
                Text("إرفاق النص")
                    .font(.system(size: 16, weight: .semibold))
                Image(systemName: "plus")
                    .font(.system(size: 14, weight: .bold))
            }
            .foregroundStyle(.black)
            .padding(.horizontal, 32)
            .padding(.vertical, 14)
            .background(.white)
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .disabled(isAnalyzing)
        .opacity(isAnalyzing ? 0.5 : 1)
        .fileImporter(
            isPresented: $showImporter,
            allowedContentTypes: [UTType(filenameExtension: "docx") ?? .data],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let urls):
                guard let url = urls.first else { return }
                loadAndAnalyze(url)
            case .failure(let error):
                errorMessage = error.localizedDescription
            }
        }
    }

    //  Pipeline

    private func loadAndAnalyze(_ url: URL) {
        errorMessage = nil
        breakdown    = nil
        isAnalyzing  = true

        Task {
            do {
                let tempURL = FileManager.default.temporaryDirectory
                    .appendingPathComponent(UUID().uuidString + ".docx")

                let accessed = url.startAccessingSecurityScopedResource()
                defer { if accessed { url.stopAccessingSecurityScopedResource() } }

                try FileManager.default.copyItem(at: url, to: tempURL)
                defer { try? FileManager.default.removeItem(at: tempURL) }

                let rawText = try Extensions.extractText(from: tempURL)

                let cleaned = rawText
                    .replacingOccurrences(of: "\n\n\n", with: "\n\n")
                    .trimmingCharacters(in: .whitespacesAndNewlines)

                let service = AIService(ApiKey: apiKey)
                let result  = try await service.analyze(screenplayText: cleaned)

                await MainActor.run {
                    breakdown   = result
                    isAnalyzing = false
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
