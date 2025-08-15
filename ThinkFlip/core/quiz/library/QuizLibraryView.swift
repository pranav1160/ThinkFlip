//
//  QuizLibraryView.swift
//  ThinkFlip
//
//  Created by Pranav on 13/08/25.
//

import SwiftUI
import SwiftData

struct QuizLibraryView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Query private var savedQuizes: [QuizResponseModel]
    
    var body: some View {
        NavigationStack {
            ZStack{
                GradientBackground()
                VStack{
                    if savedQuizes.isEmpty {
                        EmptyStateView()
                    } else {
                        List {
                            ForEach(savedQuizes) { deck in
                                NavigationLink {
                                    LibraryMCQView(
                                        viewModel: {
                                            let vm = LibraryQuizViewModel()
                                            vm.loadQuiz(from: deck)
                                            return vm
                                        }()
                                    )
                                } label: {
                                    Text("Quiz:\(deck.title ?? "No Name")") // ✅ show quiz title if you have one
                                        .frame(height: 50)
                                        .font(.title2)
                                }
                            }
                        }
                        .scrollContentBackground(.hidden)
                    }
                }
            }
        }
        .navigationTitle("Saved Decks")
    }
}


#Preview {
    QuizLibraryView()
}
