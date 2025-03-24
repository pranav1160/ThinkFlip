import SwiftUI

struct CardStackView: View {
    let allArticles: [CardModel]
    let colors: [Color]
    
    var body: some View {
        ZStack {
            // Generate views with precomputed data
            ForEach(allArticles.indices.reversed(), id: \.self) { index in
                cardView(for: index)
            }
        }
    }
    
    // Extracted function to simplify the ForEach body
    private func cardView(for index: Int) -> some View {
        let article = allArticles[index]
        let color = colors[index % colors.count]
        let rotation = Angle(degrees: Double(index - allArticles.count / 2) * 1.5)
        let offsetX = CGFloat(index - allArticles.count / 2) * 5
        let offsetY = CGFloat(index) * 1.5
        let scale = 1 - CGFloat(index) * 0.01
        
        return SwipeCardView(
            title: article.title,
            bodyText: article.description,
            frontColor: color,
            imgUrl: article.imageUrl,
            accuracy: article.accuracy
        )
        .zIndex(Double(index))
        .rotationEffect(rotation)
        .offset(x: offsetX, y: offsetY)
        .scaleEffect(scale)
    }
}

#Preview {
    CardStackView(
        allArticles: [
            CardModel(
                title: "Article 1",
                description: "This is the first article.",
                imageUrl: "https://source.unsplash.com/random/400x300",
                accuracy: 98.5
            ),
            CardModel(title: "Article 2", description: "This is the second article.", imageUrl: "https://source.unsplash.com/random/400x300", accuracy: 98.5),
            CardModel(title: "Article 3", description: "This is the third article.", imageUrl: "https://source.unsplash.com/random/400x300", accuracy: 98.5),
            CardModel(title: "Article 4", description: "This is the fourth article.", imageUrl: "https://source.unsplash.com/random/400x300", accuracy: 98.5),
            CardModel(title: "Article 5", description: "This is the fifth article.", imageUrl: "https://source.unsplash.com/random/400x300", accuracy: 98.5),
            CardModel(title: "Article 6", description: "This is the sixth article.", imageUrl: "https://source.unsplash.com/random/400x300", accuracy: 98.5)
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
