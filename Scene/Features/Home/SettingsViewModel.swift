//
//  SettingsViewModel.swift
//  Scene
//

import SwiftUI

struct SettingsViewModel: View {

    @EnvironmentObject var settings: AppSettings
    @Binding var isExpanded: Bool


    var body: some View {

        VStack(alignment: .leading, spacing: 12) {
            HStack{
                Text("Settings")
                Spacer()
                Button {
                    isExpanded = false
                } label: {
                    Image(systemName: "xmark")
                        .font(.title3.bold())
                        .foregroundColor(.white)
                }
                .buttonStyle(.plain)

            }
            Divider()
            HStack(spacing: 10) {
                Image(systemName: "person.fill")
                Text("Name")
                TextField("Name...", text: .constant(""))
                Image(systemName: "square.and.pencil")
                Spacer()
                    
            }
            .foregroundStyle(.white)
            Picker("Language", selection: $settings.language) {

                Text("English").tag(AppLanguage.english)
                Text("Arabic").tag(AppLanguage.arabic)
            }
            .pickerStyle(.segmented)
            .tint(.white)
            .padding(.top, 6)
            Spacer()

        }
        .padding(20)
        .frame(width: 519, height: 200, alignment: .topLeading)
        .glassEffect(in: RoundedRectangle(cornerRadius: 30))
    }
}
