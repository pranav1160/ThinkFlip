//
//  ContentView.swift
//  ThinkFlip
//
//  Created by Pranav on 12/04/25.
//


import SwiftUI

struct MainQuizView: View {
    @StateObject private var viewModel = QuizViewModel()

    var body: some View {
        NavigationView {
            VStack {
                MCQView(viewModel: viewModel)
                
                Spacer()
                
                Button("Start Quiz") {
                    // Optionally, start the quiz from the beginning
                    viewModel.currentQuestionIndex = 0
                    viewModel.selectedOption = nil
                    viewModel.showExplanation = false
                }
                .padding()
            }
        }
    }
}

#Preview {
    MainQuizView()
}
