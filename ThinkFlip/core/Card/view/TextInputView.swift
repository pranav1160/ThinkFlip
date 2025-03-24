import SwiftUI

struct TextInputView: View {
    @ObservedObject var viewModel: CardViewModel
    @State private var userInput: String = ""
    @State private var btnClicked:Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            
            // Header
            Text("Create Your FlashCard")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .padding(.top, 10)
            
            // Text Input Field
            TextField("Enter text here...", text: $userInput)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
                )
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.blue, lineWidth: 1))
                .padding(.horizontal)
            
            // Send Button
            Button {
                
                viewModel.sendMessage(text: userInput)
                btnClicked = true
                
            } label: {
                Text("Generate FlashCard")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(radius: 3)
                    .opacity(btnClicked ? 0.65 : 1 )
                    
            }
            .padding(.horizontal)
            
            Spacer()
            
            // Card Stack View
            VStack(alignment: .center) {
                if (!viewModel.articles.isEmpty) {
                    
                    CardStackView(
                        allArticles: viewModel.articles,
                        colors: generateColors(count: viewModel.articles.count)
                    )
                    .frame(height: 400)
                    .transition(.opacity)
                    .onAppear {
                        btnClicked = false // Reset btnClicked when articles are received
                    }
                }
                else if (viewModel.articles.isEmpty && btnClicked==true )
                {
                    ProgressView()
                }
                 else {
                    VStack {
                        Image(systemName: "rectangle.stack.badge.plus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.gray.opacity(0.5))
                        
                        Text("No FlashCards yet...")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.top, 5)
                    }
                    .padding()
                }
            }
            .frame(maxHeight: 450)
            
            Spacer()
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
    TextInputView(viewModel: CardViewModel())
}
