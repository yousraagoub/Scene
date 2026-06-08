//
//  SummaryCard.swift
//  Scene
//
import SwiftUI

struct SummaryCard: View {

    let title: String

    let count: Int

    let icon: String
    
    let color: Color

    var body: some View {

        VStack(alignment: .leading) {

            HStack {
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50)
                    .foregroundStyle(Color(color))
                    
                Text(title)
                    .font(.largeTitle)
                    .foregroundStyle(Color(color))
                
                Text("\(count)")
                    .font(.largeTitle)
                    .foregroundStyle(Color(color))
                Spacer()
            }
            .padding()

            
        }
        .padding()
        .frame(height: 150)
        .glassEffect(
            in: RoundedRectangle(cornerRadius: 24)
        )
    }
}

