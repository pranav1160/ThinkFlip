import SwiftUI

struct CardStackView: View {
    @Environment(\.dismiss) private var dismiss
    let allArticles: [CardModelDTO]
    let colors: [Color]
    @Environment(\.modelContext) private var context
    @EnvironmentObject private var cardVM:CardViewModel
    
    var body: some View {
        if allArticles.isEmpty{
            ProgressView()
        }else{
            VStack{
                ZStack {
                    // Generate views with precomputed data
                    ForEach(allArticles.indices, id: \.self) { index in
                        cardView(for: index)
                    }
                }
                
                VStack{
                    Button{
                        saveDeck()
                        cardVM.articles = []
                        dismiss()
                    }label: {
                        Text("SAVE")
                            .frame(width: 300,height: 50)
                            .background(Color.theme.blue2)
                            .foregroundStyle(.white)
                            .clipShape(.capsule)
                    }
                    
                    Button{
                        cardVM.articles = []
                        dismiss()
                    }label: {
                        Text("DISMISS")
                            .frame(width: 300,height: 50)
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
            frontColor: color
        )
        .zIndex(Double(allArticles.count - index))
        .rotationEffect(rotation)
        .offset(x: offsetX, y: offsetY)
        .scaleEffect(scale)
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
