//
//  CardViewModel.swift
//  ThinkFlip
//
//  Created by Pranav on 30/01/25.
//

import Foundation

class CardViewModel: ObservableObject {
    @Published var articles: [CardModel] = []
    
    private let apiURL = "https://thinkflip-backend.onrender.com/gemini"
    
    func sendMessage(text: String) {
        guard let url = URL(string: apiURL) else { return }
        
        let request = createPostRequest(url: url, text: text)
        
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
    
    private func createPostRequest(url: URL, text: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = MessageRequest(modelType: "text_only", prompt: text)
        
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            print("Encoding error: \(error)")
        }
        
        return request
    }
    
    private func performRequest(_ request: URLRequest, completion: @escaping (Result<MessageResponse, Error>) -> Void) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(MessageResponse.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

