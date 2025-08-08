import SwiftUI

struct DetailTextView: View {
    @EnvironmentObject var cardVM: CardViewModel
    @StateObject private var quizVM = QuizViewModel()
    
    @State private var navigateToCardView = false
    @State private var navigateToQuizView = false
    
    @State private var showCardInputSheet = false
    @State private var showQuizInputSheet = false
    
    @State private var numberOfCards = ""
    @State private var numberOfQuestions = ""
    
    let myDetailedText: String
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
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
                
                Button {
                    showCardInputSheet = true
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
                
                Button {
                    showQuizInputSheet = true
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
                CardView()
            }
            .navigationDestination(isPresented: $navigateToQuizView) {
                MCQView(viewModel: quizVM)
            }
            .sheet(isPresented: $showCardInputSheet) {
                NumberInputSheet(title: "How many cards?", value: $numberOfCards) {
                    if let count = Int(numberOfCards), count > 0 {
                        cardVM
                            .sendMessage(text: myDetailedText, number: count)
                        navigateToCardView = true
                    }
                    showCardInputSheet = false
                }
            }
            .sheet(isPresented: $showQuizInputSheet) {
                NumberInputSheet(title: "How many quiz questions?", value: $numberOfQuestions) {
                    if let count = Int(numberOfQuestions), count > 0 {
                        quizVM.fetchQuiz(from: myDetailedText, number: count)
                        navigateToQuizView = true
                    }
                    showQuizInputSheet = false
                }
            }
            .padding()
        }
    }
}
