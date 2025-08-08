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
            ScanningView()
                .environmentObject(cardVM)
                .modelContainer(for: [CardModel.self, MessageResponse.self]) // 👈 Add this
        }
    }
    
    init() {
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
    
}
