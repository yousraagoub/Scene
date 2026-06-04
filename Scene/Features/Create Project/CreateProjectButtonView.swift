//
//  CreateProjectButtonView.swift
//  Scene
//

import SwiftUI

struct CreateProjectButtonView: View {

    @ObservedObject var homeVM: HomeViewModel

    var body: some View {

        VStack(spacing: 40) {

            Image("createImg")
                .frame(width: 202, height: 95)

            Text("Create Your Project, and Leave the rest for us.")
                .font(.headline)
                .fontWeight(.medium)
                .foregroundColor(.white)

            Button {

                withAnimation(.spring(duration: 0.25)) {
                    homeVM.isCreateProjectExpanded = true
                }

            } label: {

                Label("Create New Project",
                      systemImage: "plus.circle.fill")
                    .font(.system(size: 12))
                    .padding()
                    .frame(maxWidth: 190, maxHeight: 46)
                    .foregroundStyle(.black)
            }
            .buttonStyle(.plain)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 50))
        }
        .frame(width: 432, height: 284)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.bottom, 150)
    }
}
