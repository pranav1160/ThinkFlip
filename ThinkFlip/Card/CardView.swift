//
//  CardView.swift
//  ThinkFlip
//
//  Created by Pranav on 30/01/25.
//

import SwiftUI

struct CardView: View {
    @ObservedObject var viewModel: CardViewModel
    @State private var userInput: String = ""
    
    var body: some View {
        VStack {
            TextField("Enter text", text: $userInput)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                .padding(.horizontal)

            
            Button {
                viewModel.sendMessage(text: userInput)
            }label: {
                Text("Send")
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .foregroundStyle(.white)
                    .background(.blue)
                    .clipShape(.rect(cornerRadius: 15))
            }
            .padding()
            
            List(viewModel.articles,id: \.title) { article in
                FlashCardView(myTitle: article.title, myDescription: article.description)
            }
        }
        .padding()
    }
}

#Preview {
    CardView(viewModel: CardViewModel())
       
}
