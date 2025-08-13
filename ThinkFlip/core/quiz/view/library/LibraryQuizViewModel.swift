//
//  LibraryQuizViewModel.swift
//  ThinkFlip
//
//  Created by Pranav on 13/08/25.
//


import Foundation
import SwiftData

class LibraryQuizViewModel: ObservableObject {
    @Published var questions: [Question] = []
    @Published var currentQuestionIndex: Int = 0
    @Published var selectedOption: String?
    @Published var showExplanation: Bool = false
    @Published var answerSubmitted: Bool = false
    @Published var score: Int = 0
    
    // MARK: - Load quiz from SwiftData
    func loadQuiz(from quiz: QuizResponseModel) {
        self.questions = quiz.result.map { q in
            Question(
                id: q.id,
                question: q.question,
                options: q.options,
                correctOption: q.correctOption,
                explanation: q.explanation
            )
        }
        resetQuiz()
    }
    
    // MARK: - Game logic
    func submitAnswer() {
        guard let selectedOption = selectedOption else { return }
        let currentQuestion = questions[currentQuestionIndex]
        
        answerSubmitted = true
        if selectedOption == currentQuestion.correctOption {
            showExplanation = true
            score += 1
        } else {
            showExplanation = false
        }
    }
    
    func nextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
            selectedOption = nil
            showExplanation = false
            answerSubmitted = false
        }
    }
    
    func resetQuiz() {
        currentQuestionIndex = 0
        selectedOption = nil
        showExplanation = false
        answerSubmitted = false
        score = 0
    }
}
