import SwiftUI

struct TextInputView: View {
    @EnvironmentObject var viewModel: CardViewModel
    @StateObject private var quizViewModel = QuizViewModel()
    
    @State private var userInput: String = ""
    @State private var btnClicked: Bool = false
    
    @State private var numberOfCards = ""
    @State private var numberOfQuestions = ""
    
    @State private var showCardInputSheet = false
    @State private var showQuizInputSheet = false
    @State private var navigateToQuiz = false
    @State private var navigateToCardStack = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Create Your FlashCard")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .padding(.top, 10)
                
                TextField("Enter text here...", text: $userInput)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemGray6))
                            .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
                    )
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.blue, lineWidth: 1))
                    .padding(.horizontal)
                
                // Generate FlashCard Button
                Button {
                    showCardInputSheet = true
                } label: {
                    Text("Generate FlashCard")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .shadow(radius: 3)
                        .opacity(btnClicked ? 0.65 : 1)
                }
                .padding(.horizontal)
                
                // Start Quiz Button
                Button {
                    showQuizInputSheet = true
                } label: {
                    Text("Start Quiz")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.teal]), startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .shadow(radius: 3)
                }
                .padding(.horizontal)
                
                Spacer()
                
//                // Card Stack
//                VStack(alignment: .center) {
//                    if !viewModel.articles.isEmpty {
//                        CardStackView(
//                            allArticles: viewModel.articles,
//                            colors: generateColors(count: viewModel.articles.count)
//                        )
//                        .frame(height: 400)
//                        .transition(.opacity)
//                        .onAppear {
//                            btnClicked = false
//                        }
//                    } else if viewModel.articles.isEmpty && btnClicked {
//                        ProgressView()
//                    } else {
//                        VStack {
//                            Image(systemName: "rectangle.stack.badge.plus")
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 80, height: 80)
//                                .foregroundColor(.gray.opacity(0.5))
//                            
//                            Text("No FlashCards yet...")
//                                .font(.subheadline)
//                                .foregroundColor(.gray)
//                                .padding(.top, 5)
//                        }
//                        .padding()
//                    }
//                }
//                .frame(maxHeight: 450)
                
                Spacer()
            }
            .padding()
            .sheet(isPresented: $navigateToCardStack, content: {
                CardStackView(allArticles: viewModel.articles, colors: generateColors(count: viewModel.articles.count))
            })
            .sheet(isPresented: $showCardInputSheet) {
                NumberInputSheet(title: "How many cards?", value: $numberOfCards) {
                    if let count = Int(numberOfCards), count > 0 {
                        viewModel.sendMessage(text: userInput, number: count)
                        btnClicked = true
                    }
                    showCardInputSheet = false
                    navigateToCardStack = true
                }
            }
            .sheet(isPresented: $showQuizInputSheet) {
                NumberInputSheet(title: "How many quiz questions?", value: $numberOfQuestions) {
                    if let count = Int(numberOfQuestions), count > 0 {
                        quizViewModel.fetchQuiz(from: userInput, number: count)
                        navigateToQuiz = true
                    }
                    showQuizInputSheet = false
                }
            }
            .navigationDestination(isPresented: $navigateToQuiz) {
                MCQView(viewModel: quizViewModel)
            }
        }
    }
    
    func generateColors(count: Int) -> [Color] {
        let baseColors: [Color] = [
            Color.red, Color.blue, Color.green, Color.purple, Color.orange, Color.pink, Color.teal
        ]
        return (0..<count).map { baseColors[$0 % baseColors.count] }
    }
}

#Preview {
    TextInputView()
}
