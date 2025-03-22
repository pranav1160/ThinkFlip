//
//  ContentView.swift
//  ThinkFlip
//
//  Created by Pranav on 25/01/25.
//

import SwiftUI

struct CardData: Identifiable {
    let id = UUID()
    let frontText: String
    let backText: String
}

struct ContentView: View {
    let cardData: [CardData] = [
        CardData(frontText: "Card 1 Front", backText: "Card 1 Back"),
        CardData(frontText: "Card 2 Front", backText: "Card 2 Back"),
        CardData(frontText: "Card 3 Front", backText: "Card 3 Back"),
        // ... more cards
    ]
    @State private var currentCard = 0
    @State private var offset: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    ForEach(cardData.indices, id: \.self) { index in // Use indices for correct offset
                        DummyCardView(myFront: cardData[index].frontText, myBack: cardData[index].backText)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                }
                .offset(y: offset) // Apply the offset
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            offset = value.translation.height // Update offset
                        }
                        .onEnded { value in
                            let cardHeight = geometry.size.height
                            let threshold: CGFloat = cardHeight/4 // Adjust threshold as needed
                            
                            if value.translation.height > threshold { // Scrolling down
                                withAnimation {
                                    currentCard = min(currentCard + 1, cardData.count - 1)
                                    offset = -CGFloat(currentCard) * cardHeight
                                }
                            } else if value.translation.height < -threshold { // Scrolling up
                                withAnimation {
                                    currentCard = max(currentCard - 1, 0)
                                    offset = -CGFloat(currentCard) * cardHeight
                                }
                            } else { // Not enough scroll, return to current position
                                withAnimation{
                                    offset = -CGFloat(currentCard) * cardHeight
                                }
                            }
                        }
                )
            }
        }}
}

#Preview {
    ContentView()
}
