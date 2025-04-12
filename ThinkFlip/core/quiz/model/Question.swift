import Foundation

struct Question: Identifiable, Codable {
    var id = UUID()  // Default to UUID if not present in the JSON response
    let question: String
    let options: [String]
    let correctOption: String
    let explanation: String
    
    enum CodingKeys: String, CodingKey {
        case question, options, correctOption, explanation
        // 'id' is not present in the JSON, so we won't include it in the CodingKeys
    }
}
