//
//  CardModel.swift
//  ThinkFlip
//
//  Created by Pranav on 30/01/25.
//

import Foundation

struct CardModel:Codable{
 
    let title:String
    let description:String
    let imageUrl:String
    let accuracy:Float
}



struct MessageRequest: Codable {
    let modelType: String
    let prompt: String
}


struct MessageResponse: Codable {
    let result: [CardModel]
}
