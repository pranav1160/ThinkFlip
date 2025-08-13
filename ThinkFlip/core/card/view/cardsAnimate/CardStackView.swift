import SwiftUI

struct CardStackView: View {
    @Environment(\.dismiss) private var dismiss
    let allArticles: [CardModelDTO]
    let colors: [Color]
    @Environment(\.modelContext) private var context
    @EnvironmentObject private var cardVM: CardViewModel
    
    // Track the current top card index and swiped cards
    @State private var currentTopIndex: Int = 0
    @State private var swipedCards: Set<Int> = []
    
    var body: some View {
        if allArticles.isEmpty {
            ProgressView()
        } else {
            VStack {
                ZStack {
                    // Generate views with circular positioning
                    ForEach(allArticles.indices, id: \.self) { index in
                        cardView(for: index)
                    }
                }
                
                VStack {
                    Button {
                        saveDeck()
                        cardVM.articles = []
                        dismiss()
                    } label: {
                        Text("SAVE")
                            .frame(width: 300, height: 50)
                            .background(Color.theme.blue2)
                            .foregroundStyle(.white)
                            .clipShape(.capsule)
                    }
                    
                    Button {
                        cardVM.articles = []
                        dismiss()
                    } label: {
                        Text("DISMISS")
                            .frame(width: 300, height: 50)
                            .background(Color.red)
                            .foregroundStyle(.white)
                            .clipShape(.capsule)
                    }
                }
            }
        }
    }
    
    func saveDeck() {
        let response = MessageResponse()
        response.result = allArticles.map {
            CardModel(title: $0.title, description: $0.description)
        }
        
        context.insert(response)
        
        do {
            try context.save()
            print("Saved deck with \(response.result.count) cards ✅")
        } catch {
            print("Failed to save deck ❌: \(error)")
        }
    }
    
    // Calculate the display position of each card in the circular stack
    private func getDisplayIndex(for originalIndex: Int) -> Int {
        let totalCards = allArticles.count
        let relativePosition = (originalIndex - currentTopIndex + totalCards) % totalCards
        return relativePosition
    }
    
    // Extracted function to simplify the ForEach body with circular logic
    private func cardView(for originalIndex: Int) -> some View {
        let article = allArticles[originalIndex]
        let color = colors[originalIndex % colors.count]
        let displayIndex = getDisplayIndex(for: originalIndex)
        
        // Only show a limited number of cards in the stack (e.g., top 5)
        let maxVisibleCards = min(5, allArticles.count)
        let isVisible = displayIndex < maxVisibleCards
        
        let rotation = Angle(degrees: Double(displayIndex - maxVisibleCards / 2) * 1.5)
        let offsetX = CGFloat(displayIndex - maxVisibleCards / 2) * 5
        let offsetY = CGFloat(displayIndex) * 1.5
        let scale = 1 - CGFloat(displayIndex) * 0.01
        
        return SwipeCardView(
            title: article.title,
            bodyText: article.description,
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
                currentTopIndex = (currentTopIndex + 1) % allArticles.count
            }
        }
    }
}

#Preview {
    CardStackView(
        allArticles: [
            CardModelDTO(title: "Article 1",description: "This is the first article.",),
            CardModelDTO(title: "Article 2", description: "This is the second article."),
            CardModelDTO(title: "Article 3", description: "This is the third article."),
            CardModelDTO(title: "Article 4", description: "This is the fourth article."),
            CardModelDTO(title: "Article 5", description: "This is the fifth article."),
            CardModelDTO(title: "Article 6", description: "This is the sixth article.")
        ],
        colors: [
            Color.red,
            Color.blue,
            Color.green,
            Color.purple,
            Color.orange,
            Color.pink,
            Color.teal
        ]
    )
}
