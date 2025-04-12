//
//  QuizViewModel.swift
//  ThinkFlip
//
//  Created by Pranav on 12/04/25.
//


import Foundation
import Combine

class QuizViewModel: ObservableObject {
    @Published var questions: [Question] = []
    @Published var currentQuestionIndex: Int = 0
    @Published var selectedOption: String?
    @Published var showExplanation: Bool = false
    @Published var answerSubmitted: Bool = false  // Added missing property
    @Published var isLoading = false
    @Published var score: Int = 0  // Track user's score
    private var cancellables = Set<AnyCancellable>()
    
    // Submit the user's answer and check if it's correct
    func submitAnswer() {
        guard let selectedOption = selectedOption else { return }
        let currentQuestion = questions[currentQuestionIndex]
        
        answerSubmitted = true
        
        // Check if answer is correct
        if selectedOption == currentQuestion.correctOption {
            showExplanation = true
            score += 1
        } else {
            showExplanation = false
        }
    }
    
    // Move to the next question and reset state
    func nextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
            selectedOption = nil
            showExplanation = false
            answerSubmitted = false
        }
    }
    
    // Reset the quiz to start over
    func resetQuiz() {
        currentQuestionIndex = 0
        selectedOption = nil
        showExplanation = false
        answerSubmitted = false
        score = 0
    }
    

    
    func fetchQuiz(from text: String) {
        guard let url = URL(string: "https://thinkflip-backend.onrender.com/gemini/mcq") else {
            return
        }
        
        let payload: [String: Any] = [
            "modelType": "text_only",
            "prompt": text
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: payload) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        isLoading = true
        print("🚀 Sending request to \(url)...")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
            }
            
            if let error = error {
                print("❌ Request failed with error: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("📡 Response status code: \(httpResponse.statusCode)")
            }
            
            guard let data = data else {
                print("❌ No data received")
                return
            }
            
            // Try to print raw response for debugging
            if let rawString = String(data: data, encoding: .utf8) {
                print("📦 Raw response:\n\(rawString)")
            }
            
            struct APIResponse: Codable {
                let result: [Question]
            }
            
            do {
                let decoded = try JSONDecoder().decode(APIResponse.self, from: data)
                DispatchQueue.main.async {
                    self.questions = decoded.result
                    print("✅ Decoded \(decoded.result.count) questions")
                    self.resetQuiz()
                }
            } catch {
                print("❌ Decoding failed: \(error)")
            }
            
        }.resume()
    }

}

