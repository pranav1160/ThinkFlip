import SwiftUI

struct MCQView: View {
    @ObservedObject var viewModel: QuizViewModel
    
    var body: some View {
        VStack {
            // Header with score display
            HStack {
                Text("Quiz")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Score: \(viewModel.score)")
                        .font(.headline)
                        .foregroundColor(.blue)
                    
                    Text("Question \(viewModel.currentQuestionIndex + 1) of \(viewModel.questions.count)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal)
            
            // Progress bar
            if !viewModel.questions.isEmpty {
                ProgressView(value: Double(viewModel.currentQuestionIndex + 1), total: Double(viewModel.questions.count))
                    .progressViewStyle(LinearProgressViewStyle())
                    .padding(.horizontal)
            }
            
            if !viewModel.questions.isEmpty,
               viewModel.currentQuestionIndex < viewModel.questions.count {
                
                let currentQuestion = viewModel.questions[viewModel.currentQuestionIndex]
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text(currentQuestion.question)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding()
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(spacing: 12) {
                            ForEach(currentQuestion.options.indices, id: \.self) { index in
                                let option = currentQuestion.options[index]
                                let optionLetter = ["A", "B", "C", "D", "E"][min(index, 4)]
                                
                                Button(action: {
                                    if !viewModel.answerSubmitted {
                                        viewModel.selectedOption = option
                                    }
                                }) {
                                    HStack(alignment: .top) {
                                        Text("\(optionLetter).")
                                            .font(.headline)
                                            .frame(width: 25, alignment: .leading)
                                        
                                        Text(option)
                                            .multilineTextAlignment(.leading)
                                        
                                        Spacer()
                                        
                                        if viewModel.answerSubmitted {
                                            if option == currentQuestion.correctOption {
                                                Image(systemName: "checkmark.circle.fill")
                                                    .foregroundColor(.green)
                                            } else if option == viewModel.selectedOption {
                                                Image(systemName: "xmark.circle.fill")
                                                    .foregroundColor(.red)
                                            }
                                        }
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(backgroundColor(for: option))
                                    )
                                    .foregroundColor(viewModel.selectedOption == option ? .white : .primary)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(viewModel.selectedOption == option ? Color.blue : Color.gray.opacity(0.3), lineWidth: 1)
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                                .disabled(viewModel.answerSubmitted)
                            }
                        }
                        .padding(.horizontal)
                        
                        if viewModel.answerSubmitted {
                            VStack(alignment: .leading, spacing: 10) {
                                Text(viewModel.showExplanation ? "Correct! 👏" : "Incorrect ❌")
                                    .font(.headline)
                                    .foregroundColor(viewModel.showExplanation ? .green : .red)
                                
                                if !viewModel.showExplanation {
                                    Text("Correct answer: \(currentQuestion.correctOption)")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                }
                                
                                Text("Explanation:")
                                    .font(.headline)
                                    .padding(.top, 5)
                                
                                Text(currentQuestion.explanation)
                                    .padding(.vertical, 5)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(viewModel.showExplanation ? UIColor.systemGreen.withAlphaComponent(0.1) : UIColor.systemRed.withAlphaComponent(0.1)))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(viewModel.showExplanation ? Color.green.opacity(0.3) : Color.red.opacity(0.3), lineWidth: 1)
                            )
                            .padding(.horizontal)
                        }
                    }
                }
                
                Spacer()
                
                // Bottom navigation area
                VStack(spacing: 15) {
                    if !viewModel.answerSubmitted && viewModel.selectedOption != nil {
                        Button(action: {
                            viewModel.submitAnswer()
                        }) {
                            Text("Submit Answer")
                                .fontWeight(.semibold)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    } else if viewModel.answerSubmitted {
                        if viewModel.currentQuestionIndex < viewModel.questions.count - 1 {
                            Button(action: {
                                viewModel.nextQuestion()
                            }) {
                                Text("Next Question")
                                    .fontWeight(.semibold)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        } else {
                            VStack(spacing: 10) {
                                Text("🎉 Quiz Completed!")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                
                                Text("Final Score: \(viewModel.score)/\(viewModel.questions.count)")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                
                                let percentage = Double(viewModel.score) / Double(viewModel.questions.count) * 100
                                Text("\(Int(percentage))%")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(
                                        percentage >= 80 ? .green :
                                            percentage >= 60 ? .orange : .red
                                    )
                                
                                Button(action: {
                                    viewModel.resetQuiz()
                                }) {
                                    Text("Restart Quiz")
                                        .fontWeight(.semibold)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                                .padding(.top)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(15)
                        }
                    }
                }
                .padding(.horizontal)
                
            } else if viewModel.isLoading {
                Spacer()
                ProgressView("Loading questions...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
                Spacer()
            } else {
                Spacer()
                Text("No questions available")
                    .font(.headline)
                    .foregroundColor(.secondary)
                Spacer()
            }
        }
        .padding(.vertical)
    }
    
    // Helper function to determine the background color for options
    private func backgroundColor(for option: String) -> Color {
        if !viewModel.answerSubmitted {
            return viewModel.selectedOption == option ? Color.blue : Color.gray.opacity(0.1)
        } else {
            if option == viewModel.questions[viewModel.currentQuestionIndex].correctOption {
                return Color.green.opacity(0.2)
            } else if option == viewModel.selectedOption {
                return Color.red.opacity(0.2)
            } else {
                return Color.gray.opacity(0.1)
            }
        }
    }
}

// Preview provider for SwiftUI Canvas
struct MCQView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = QuizViewModel()
        viewModel.questions = [
            Question(
                question: "What is the capital of France?",
                options: ["London", "Paris", "Berlin", "Madrid"],
                correctOption: "Paris",
                explanation: "Paris is the capital and most populous city of France."
            ),
            Question(
                question: "Which planet is known as the Red Planet?",
                options: ["Venus", "Mars", "Jupiter", "Saturn"],
                correctOption: "Mars",
                explanation: "Mars is called the Red Planet because of its reddish appearance."
            )
        ]
        return MCQView(viewModel: viewModel)
    }
}

