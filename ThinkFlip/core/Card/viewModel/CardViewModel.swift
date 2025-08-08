//
//  CardViewModel.swift
//  ThinkFlip
//
//  Created by Pranav on 30/01/25.
//

import Foundation
import SwiftData

class CardViewModel: ObservableObject {
    @Published var articles: [CardModelDTO] = []
    
    private let apiURL = "https://thinkflip-backend.onrender.com/gemini"
    
    func sendMessage(text: String,number:Int) {
        guard let url = URL(string: apiURL) else { return }
        
        let request = createPostRequest(url: url, text: text, number: number)
        
        performRequest(request) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.articles = response.result
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func createPostRequest(url: URL, text: String,number:Int) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = MessageRequest(
            modelType: "text_only",
            prompt: text,
            number:number
        )
        
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            print("Encoding error: \(error)")
        }
        
        return request
    }
    
    private func performRequest(
        _ request: URLRequest,
        completion: @escaping (Result<MessageResponseDTO, Error>) -> Void
    ) {
        URLSession.shared.dataTask(with: request) {
            data,
            response,
            error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(
                    MessageResponseDTO.self,
                    from: data
                )
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    
}

