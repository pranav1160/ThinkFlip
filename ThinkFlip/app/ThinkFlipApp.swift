//
//  ThinkFlipApp.swift
//  ThinkFlip
//
//  Created by Pranav on 25/01/25.
//

import SwiftUI
import SwiftData

@main
struct ThinkFlipApp: App {
    @StateObject var cardVM = CardViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(cardVM)
                .modelContainer(for: [
                    CardModel.self,
                    MessageResponse.self,
                    QuizResponseModel.self,
                    QuestionModel.self
                ])
        }
    }
    
    init() {
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
    
}
