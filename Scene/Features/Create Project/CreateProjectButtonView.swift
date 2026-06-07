//
//  CreateProjectButtonView.swift
//  Scene
//

import SwiftUI

struct CreateProjectButtonView: View {

    @ObservedObject var homeVM: HomeViewModel

    var body: some View {
        VStack(spacing: 50) {
            Image("createImg")
                .resizable()
                .scaledToFit()
                .frame(width: 200)

            Text("Create Your Project and Leave the rest for us.")
                .multilineTextAlignment(.center)
                .font(.largeTitle)
                .foregroundColor(.white)

            Button {

                withAnimation(.spring(duration: 0.25)) {
                    homeVM.isCreateProjectExpanded = true
                }

            } label: {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 22)
                    .foregroundStyle(.black)
                Text("Create New Project")
                    .font(.title)
                    .foregroundStyle(.black)
            }
            .padding()
            .buttonStyle(.plain)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 50))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.bottom, 150)
    }
}
