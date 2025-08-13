//
//  LibraryMCQView.swift
//  ThinkFlip
//
//  Created by Pranav on 13/08/25.
//

import SwiftUI

struct LibraryMCQView: View {
    
    @ObservedObject var viewModel: LibraryQuizViewModel
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            // Header
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
            
            // Question + Options
            if !viewModel.questions.isEmpty,
               viewModel.currentQuestionIndex < viewModel.questions.count {
                
                let currentQuestion = viewModel.questions[viewModel.currentQuestionIndex]
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text(currentQuestion.question)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(spacing: 12) {
                            ForEach(currentQuestion.options.indices, id: \.self) { index in
                                let option = currentQuestion.options[index]
                                let optionLetter = ["A", "B", "C", "D", "E"][min(index, 4)]
                                
                                Button {
                                    if !viewModel.answerSubmitted {
                                        viewModel.selectedOption = option
                                    }
                                } label: {
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
                                .buttonStyle(.plain)
                                .disabled(viewModel.answerSubmitted)
                            }
                        }
                        .padding(.horizontal)
                        
                        // Explanation section
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
                            .frame(maxWidth:.infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(viewModel.showExplanation ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
                                    
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(viewModel.showExplanation ? Color.green.opacity(0.3) : Color.red.opacity(0.3), lineWidth: 1)
                                   
                            )
                            .padding()
                        }
                    }
                }
                
                Spacer()
                
                // Bottom navigation buttons
                VStack(spacing: 15) {
                    if !viewModel.answerSubmitted && viewModel.selectedOption != nil {
                        Button("Submit Answer") {
                            viewModel.submitAnswer()
                        }
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        
                    } else if viewModel.answerSubmitted {
                        if viewModel.currentQuestionIndex < viewModel.questions.count - 1 {
                            Button("Next Question") {
                                viewModel.nextQuestion()
                            }
                            .fontWeight(.semibold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            
                        } else {
                            quizCompletionView
                        }
                    }
                }
                .padding(.horizontal)
                
            } else if viewModel.questions.isEmpty {
                Spacer()
                Text("No questions available")
                    .font(.headline)
                    .foregroundColor(.secondary)
                Spacer()
            }
        }
        .padding(.vertical)
    }
    
    private var quizCompletionView: some View {
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
            
            Button("Restart Quiz") {
                viewModel.resetQuiz()
            }
            .fontWeight(.semibold)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.top)
            
            Button("Exit") {
                dismiss()
            }
            .fontWeight(.semibold)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(15)
    }
    
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

#Preview {
    LibraryMCQView(
        viewModel: {
            let vm = LibraryQuizViewModel()
            vm.questions = [
                Question(id: UUID(), question: "Sample Q?", options: ["A", "B", "C"], correctOption: "B", explanation: "Because it is.")
            ]
            return vm
        }()
    )
}
