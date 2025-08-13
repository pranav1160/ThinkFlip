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
    
    // Track the current top card index and swiped cards
    @State private var currentTopIndex: Int = 0
    @State private var swipedCards: Set<Int> = []
    
    var body: some View {
        if deck.result.isEmpty {
            VStack {
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
                    // Generate views with circular positioning
                    ForEach(deck.result.indices, id: \.self) { index in
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
    
    // Calculate the display position of each card in the circular stack
    private func getDisplayIndex(for originalIndex: Int) -> Int {
        let totalCards = deck.result.count
        let relativePosition = (originalIndex - currentTopIndex + totalCards) % totalCards
        return relativePosition
    }
    
    // Updated cardView function with circular logic
    private func cardView(for originalIndex: Int) -> some View {
        let article = deck.result[originalIndex]
        let color = colors[originalIndex % colors.count]
        let displayIndex = getDisplayIndex(for: originalIndex)
        
        // Only show a limited number of cards in the stack (e.g., top 5)
        let maxVisibleCards = min(5, deck.result.count)
        let isVisible = displayIndex < maxVisibleCards
        
        let rotation = Angle(degrees: Double(displayIndex - maxVisibleCards / 2) * 1.5)
        let offsetX = CGFloat(displayIndex - maxVisibleCards / 2) * 5
        let offsetY = CGFloat(displayIndex) * 1.5
        let scale = 1 - CGFloat(displayIndex) * 0.01
        
        return SwipeCardView(
            title: article.title,
            bodyText: article.cardDescription,
            frontColor: color,
            onSwipeLeft: { handleSwipe(for: originalIndex) },
            onSwipeRight: { handleSwipe(for: originalIndex) }
        )
        .zIndex(Double(maxVisibleCards - displayIndex))
        .rotationEffect(rotation)
        .offset(x: offsetX, y: offsetY)
        .scaleEffect(scale)
        .opacity(isVisible ? 1 : 0)
        .animation(.easeInOut(duration: 0.3), value: currentTopIndex)
    }
    
    // Handle card swipe and move to next card
    private func handleSwipe(for cardIndex: Int) {
        // Mark card as swiped
        swipedCards.insert(cardIndex)
        
        // Move to next card with delay to allow swipe animation to complete
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeInOut(duration: 0.3)) {
                currentTopIndex = (currentTopIndex + 1) % deck.result.count
            }
        }
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
