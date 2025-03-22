import SwiftUI

struct CardView: View {
    @ObservedObject var viewModel: CardViewModel
    @State private var userInput: String = ""
    
    var body: some View {
        VStack {
            // Show CardStackView only if there are articles
            if !viewModel.articles.isEmpty {
                CardStackView(
                    allArticles: viewModel.articles,
                    colors: generateColors(count: viewModel.articles.count)
                )
               
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5) // Make it larger
                    .padding()
            }
        }
        .padding()
    }
    
    // Function to generate a color array matching the number of articles
    func generateColors(count: Int) -> [Color] {
        let baseColors: [Color] = [
            Color.red, Color.blue, Color.green, Color.purple, Color.orange, Color.pink, Color.teal
        ]
        return (0..<count).map { baseColors[$0 % baseColors.count] } // Repeat colors if needed
    }
}

#Preview {
    CardView(viewModel: CardViewModel())
}
