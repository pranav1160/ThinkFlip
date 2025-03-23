//
//  LibraryModel.swift
//  ThinkFlip
//
//  Created by Pranav on 24/03/25.
//

import Foundation

struct ScannedDoc: Codable, Identifiable {
    let id: String
    let user: String
    let content: String
    let date: Date
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case user
        case content
        case date
    }
}

// The API might return data in different formats
struct ScannedHistoryResponseWrapper: Codable {
    let history: [ScannedDoc]
}


// Define structures for error responses
struct ErrorResponse: Codable {
    let message: String
}

