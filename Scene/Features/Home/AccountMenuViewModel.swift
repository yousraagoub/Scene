//
//  AccountMenuModalView.swift
//  Scene
//

import SwiftUI

struct AccountMenuModalView: View {

    @EnvironmentObject var settings: AppSettings   // ✅ REAL shared instance
    @Binding var isExpanded: Bool

    let onDeleteAccount: () -> Void

    var body: some View {

        VStack(spacing: 12) {

            HStack(spacing: 10) {

                Circle()
                    .fill(Color.primaryRed.gradient)
                    .frame(width: 52, height: 52)
                    .overlay {
                        Image(systemName: "person.fill")
                            .foregroundStyle(.white)
                            .font(.title3.bold())
                    }

                Text("John Appleseed")
                    .font(.headline)

                Spacer()
            }

            Divider()

            MenuActionButton(
                title: "Settings",
                systemImage: "gearshape.fill",
                role: .normal,
                action: {}
            )

            MenuActionButton(
                title: "Delete Account",
                systemImage: "trash.fill",
                role: .destructive,
                action: onDeleteAccount
            )

            Picker("Language", selection: $settings.language) {

                Text("English").tag(AppLanguage.english)
                Text("Arabic").tag(AppLanguage.arabic)
            }
            .pickerStyle(.segmented)
            .tint(.primaryRed)
            .padding(.top, 6)

        }
        .padding(20)
        .frame(width: 519, height: 382)
        .glassEffect(in: RoundedRectangle(cornerRadius: 30))
//        .background(.ultraThinMaterial)
//        .clipShape(RoundedRectangle(cornerRadius: 18))
//        .shadow(color: .black.opacity(0.25), radius: 30, x: 0, y: 10)
    }
}
