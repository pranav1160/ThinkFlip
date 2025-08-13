//
//  CardData.swift
//  ThinkFlip
//
//  Created by Pranav on 25/01/25.
//

import Foundation
import SwiftData

struct MessageResponseDTO: Codable {
    let result: [CardModelDTO]
}

@Model
class MessageResponse {
    @Relationship var result: [CardModel] = []
    
    init() {}
}


struct MessageRequest: Codable {
    let modelType: String
    let prompt: String
    let number: Int
}
