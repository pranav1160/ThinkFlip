//
//  CardModel.swift
//  ThinkFlip
//
//  Created by Pranav on 30/01/25.
//
import Foundation
import SwiftData


@Model
class CardModel {
    var title: String
    var cardDescription: String
    
    @Relationship(inverse: \MessageResponse.result)
    var response: MessageResponse?
    
    init(title: String, description: String, response: MessageResponse? = nil) {
        self.title = title
        self.cardDescription = description
        self.response = response
    }
}


// DTO for decoding JSON from API
struct CardModelDTO: Codable {
    let title: String
    let description: String
}


extension CardModelDTO {
    func toModel(context: ModelContext, response: MessageResponse? = nil) -> CardModel {
        let card = CardModel(
            title: title,
            description: description,
            response: response
        )
        context.insert(card)
        return card
    }
}
