//
//  CardViewModel.swift
//  ThinkFlip
//
//  Created by Pranav on 30/01/25.
//
import Foundation


import Foundation
class CardViewModel: ObservableObject {
    @Published var articles: [CardModel] = []
    
    func sendMessage(text: String) {
        guard let url = URL(string: "https://thinkflip-backend.onrender.com/gemini") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = MessageRequest(modelType: "text_only", prompt: text)
        
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            print("Encoding error: \(error)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                // ✅ Print raw response for debugging
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("🔹 Raw API Response: \(jsonString)")
                }
                
                DispatchQueue.main.async {
                    do {
                        let decodedResponse = try JSONDecoder().decode(MessageResponse.self, from: data)
                        self.articles = decodedResponse.result

                    } catch {
                        print("❌ Decoding error: \(error)")
                    }
                }
            } else if let error = error {
                print("❌ Network error: \(error)")
            }
        }.resume()
    }
}
