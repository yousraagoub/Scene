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

                TextField(
                    "Enter title",
                    text: $title
                )
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

                Picker(
                    "Production Type",
                    selection: $selectedScriptType
                ) {

                    ForEach(
                        ScriptType.allCases,
                        id: \.self
                    ) {
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

                    Label("Upload Script",
                          systemImage: "plus.circle.fill")
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

            HStack {

                Spacer()

                Button("Submit") {
                    //MARK: - Dummy Data:
                    let scene1 = SceneBreakdown(
                        number: 1,
                        title: "Coffee Shop",
                        characters: [
                            CharacterBreakdown(
                                name: "John",
                                role: "Lead"
                            )
                        ],
                        locations: [
                            LocationBreakdown(
                                name: "Coffee Shop",
                                type: "Interior"
                            )
                        ],
                        props: [
                            PropBreakdown(
                                name: "Notebook"
                            )
                        ],
                        visualEffects: [
                            "Rain"
                        ]
                    )

                    let scene2 = SceneBreakdown(
                        number: 2,
                        title: "Street",
                        characters: [
                            CharacterBreakdown(
                                name: "Sarah",
                                role: "Support"
                            )
                        ],
                        locations: [
                            LocationBreakdown(
                                name: "Street",
                                type: "Exterior"
                            )
                        ],
                        props: [
                            PropBreakdown(
                                name: "Phone"
                            )
                        ],
                        visualEffects: [
                            "Explosion"
                        ]
                    )

                    let breakdown = ScriptBreakdown(
                        scenes: [
                            scene1,
                            scene2
                        ],
                        totalCharacters: [
                            CharacterBreakdown(
                                name: "John",
                                role: "Lead"
                            ),
                            CharacterBreakdown(
                                name: "Sarah",
                                role: "Support"
                            )
                        ],
                        totalLocations: [
                            LocationBreakdown(
                                name: "Coffee Shop",
                                type: "Interior"
                            ),
                            LocationBreakdown(
                                name: "Street",
                                type: "Exterior"
                            )
                        ],
                        totalProps: [
                            PropBreakdown(name: "Notebook"),
                            PropBreakdown(name: "Phone")
                        ],
                        totalVisualEffects: [
                            "Rain",
                            "Explosion"
                        ]
                    )
                    let project = ProjectModel(
                        title: title,
                        genre: selectedGenre,
                        scriptType: selectedScriptType,
                        fileURL: fileURL,
                        breakdown: breakdown
                    )

                    homeVM.projects.append(project)

                    homeVM.selectedProject = project

                    homeVM.selectedSection = .breakdown

                    isExpanded = false
                }
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
        .fileImporter(
            isPresented: $importingFile,
            allowedContentTypes: [
                .plainText,
                .data
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
}
