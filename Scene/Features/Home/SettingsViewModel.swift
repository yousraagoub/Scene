//
//  SettingsViewModel.swift
//  Scene
//

import SwiftUI

struct SettingsViewModel: View {

    @EnvironmentObject var settings: AppSettings
    @State private var isEditingName = false
    @Binding var isExpanded: Bool
    @State private var hoverProjects = false


    var body: some View {

        VStack(alignment: .leading, spacing: 18) {
            HStack{
                Text("Settings")
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
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16)
                Text("Name")
                TextField("Name...", text: $settings.userName)
                    .disabled(!isEditingName)

                Button {
                    isEditingName.toggle()
                } label: {
                    Image(systemName: "square.and.pencil")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18)
                        .foregroundColor(.white.opacity(hoverProjects ? 1 : 0.6))
                }
                .buttonStyle(.plain)
                .onHover { hoverProjects = $0 }
                Spacer()
                    
            }
            .font(.title2)
            .foregroundColor(.white)
            
            HStack {
                Text("Language")
                    .font(.title2)
                    .foregroundStyle(.white)

                HStack(spacing: 0) {

                    ForEach(AppLanguage.allCases, id: \.self) { language in
                        Button {
                            settings.language = language
                        } label: {
                            Text(language == .english ? "English" : "Arabic")
                                .font(.title2)
                                .frame(width: 90)
                                .fixedSize(horizontal: true, vertical: true)
                        }
                        .buttonStyle(.plain)
                        .background(settings.language == language ? Color.white : Color.clear)
                        .foregroundStyle(settings.language == language ? .black : .white)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(.white.opacity(0.3)))
            }

        }
        .padding()
        .frame(width: 519, alignment: .topLeading)
        .fixedSize(horizontal: false, vertical: true)
        .glassEffect(in: RoundedRectangle(cornerRadius: 30))
    }
}
