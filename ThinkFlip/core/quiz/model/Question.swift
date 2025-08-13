

import Foundation
import SwiftData




struct QuizResponseDTO: Codable {
    let result: [Question]
}


struct Question: Identifiable, Codable {
    var id = UUID()  // Default to UUID if not present in the JSON response
    let question: String
    let options: [String]
    let correctOption: String
    let explanation: String
    
    enum CodingKeys: String, CodingKey {
        case question, options, correctOption, explanation
    }
}


//MARK: - SWIFT DATA MODELS

@Model
class QuizResponseModel {
    var title:String?
    var result: [QuestionModel]
    
    init(title: String? = nil, result: [QuestionModel]) {
        self.title = title
        self.result = result
    }
}

@Model
class QuestionModel {
    var id: UUID
    var question: String
    var options: [String]
    var correctOption: String
    var explanation: String
    
    init(id: UUID = UUID(), question: String, options: [String], correctOption: String, explanation: String) {
        self.id = id
        self.question = question
        self.options = options
        self.correctOption = correctOption
        self.explanation = explanation
    }
}


extension QuizResponseDTO {
    func toModel(withTitle title: String) -> QuizResponseModel {
        let questionModels: [QuestionModel] = result.map { dto in
            QuestionModel(
                question: dto.question,
                options: dto.options,
                correctOption: dto.correctOption,
                explanation: dto.explanation
            )
        }
        return QuizResponseModel(title: title, result: questionModels)
    }
}
