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
                .resizable()
                .scaledToFit()
                .frame(width: 252, height: 145)

            Text("Create Your Project")
                .font(.largeTitle)
                .fontWeight(.medium)
                .foregroundColor(.white)

            Button {

                withAnimation(.spring(duration: 0.25)) {
                    homeVM.isCreateProjectExpanded = true
                }

            } label: {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
                    .foregroundColor(.black)
                Text("Create New Project")
                    .font(.title)
                    .fontWeight(.medium)
                    .foregroundColor(.black)
            }
            .buttonStyle(.plain)
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 50))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.bottom, 150)
    }
}
