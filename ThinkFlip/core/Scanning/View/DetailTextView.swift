import SwiftUI

struct DetailTextView: View {
    @StateObject private var cardVM = CardViewModel()
    @StateObject private var quizVM = QuizViewModel() // ✅ Quiz ViewModel
    
    @State private var navigateToCardView = false
    @State private var navigateToQuizView = false
    
    let myDetailedText: String
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // **Scrollable Text View**
                ScrollView {
                    Text(myDetailedText)
                        .font(.body)
                        .foregroundColor(.primary)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemGray6))
                }
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
                .frame(height: 550)
                
                Spacer()
                
                // **Create Card Button**
                Button {
                    cardVM.sendMessage(text: myDetailedText)
                    navigateToCardView = true
                } label: {
                    Text("Create Card")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .shadow(radius: 3)
                }
                .padding(.horizontal)
                
                // ✅ Start Quiz Button
                Button {
                    print("Fetching quiz with text: \(myDetailedText)") 
                    quizVM.fetchQuiz(from: myDetailedText)
                    navigateToQuizView = true
                } label: {
                    Text("Start Quiz")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.teal]), startPoint: .leading, endPoint: .trailing))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .shadow(radius: 3)
                }
                .padding(.horizontal)
            }
            .navigationDestination(isPresented: $navigateToCardView) {
                CardView(viewModel: cardVM)
            }
            .navigationDestination(isPresented: $navigateToQuizView) {
                MCQView(viewModel: quizVM)
            }
            .padding()
        }
    }
}

#Preview {
    DetailTextView(myDetailedText: "One Piece** is a popular Japanese manga and anime series created by Eiichiro Oda. It follows the adventures of Monkey D. Luffy, a young pirate with the ability to stretch his body like rubber after eating a mysterious fruit known as the Gum-Gum Fruit. Luffy and his diverse crew of pirates, known as the Straw Hat Pirates, sail the Grand Line in search of the legendary treasure called One Piece, which will make Luffy the Pirate King. The series is renowned for its rich world-building, emotional depth, and unique characters, blending action, humor, and heart-wrenching moments. Over the years, **One Piece** has become one of the most successful and influential anime and manga series worldwide.")
}
