//
//  LibraryStackView.swift
//  ThinkFlip
//
//  Created by Pranav on 08/08/25.
//

import SwiftUI

struct LibraryStackView: View {
    @Environment(\.dismiss) private var dismiss
    let deck: MessageResponse
    let colors: [Color]
    @Environment(\.modelContext) private var context
    
    var body: some View {
        if deck.result.isEmpty {
            VStack{
                ProgressView()
                
                Button {
                    deleteDeck()
                    dismiss()
                } label: {
                    Text("DELETE")
                        .frame(width: 300, height: 50)
                        .background(Color.red)
                        .foregroundStyle(.white)
                        .clipShape(.capsule)
                }
            }
           
        } else {
            VStack {
                ZStack {
                    ForEach(
                        deck.result.indices.reversed(),
                        id: \.self
                    ) { index in
                        cardView(for: index)
                    }
                }
                
                VStack {
                    Button {
                        deleteDeck()
                        dismiss()
                    } label: {
                        Text("DELETE")
                            .frame(width: 300, height: 50)
                            .background(Color.red)
                            .foregroundStyle(.white)
                            .clipShape(.capsule)
                    }
                    
                    Button {
                        dismiss()
                    } label: {
                        Text("DISMISS")
                            .frame(width: 300, height: 50)
                            .background(Color.blue)
                            .foregroundStyle(.white)
                            .clipShape(.capsule)
                    }
                }
            }
        }
    }
    
    func deleteDeck() {
        context.delete(deck)
        do {
            try context.save()
            print("Deck deleted ✅")
        } catch {
            print("Failed to delete deck ❌: \(error)")
        }
    }
    
    private func cardView(for index: Int) -> some View {
        let article = deck.result[index]
        let color = colors[index % colors.count]
        let rotation = Angle(degrees: Double(index - deck.result.count / 2) * 1.5)
        let offsetX = CGFloat(index - deck.result.count / 2) * 5
        let offsetY = CGFloat(index) * 1.5
        let scale = 1 - CGFloat(index) * 0.01
        
        return SwipeCardView(
            title: article.title,
            bodyText: article.cardDescription,
            frontColor: color
        )
        .zIndex(Double(deck.result.count - index))
        .rotationEffect(rotation)
        .offset(x: offsetX, y: offsetY)
        .scaleEffect(scale)
    }
}

#Preview {
    let sampleDeck = MessageResponse()
    sampleDeck.result = [
        CardModel(title: "Sample 1", description: "First example card"),
        CardModel(title: "Sample 2", description: "Second example card"),
        CardModel(title: "Sample 3", description: "Third example card")
    ]
    
    return LibraryStackView(
        deck: sampleDeck,
        colors: [.blue, .red, .green]
    )
    .modelContainer(for: MessageResponse.self, inMemory: true)
}
