import SwiftUI

class AuthService {
    static let shared = AuthService()
    
    private init() {
        print("AuthService initialized")
    }
    
    private let baseURL = "https://thinkflip-backend.onrender.com/auth"
    
    func register(username: String, email: String, password: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
        print("Starting registration for user: \(username), email: \(email)")
        
        guard let url = URL(string: "\(baseURL)/signup") else {
            print("Error: Invalid URL for registration")
            return
        }
        
        print("Registration URL: \(url.absoluteString)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["name": username, "email": email, "password": password]
        print("Registration request body: \(body)")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
            print("Request body serialized successfully")
        } catch {
            print("Error serializing request body: \(error.localizedDescription)")
            completion(.failure(error))
            return
        }
        
        print("Sending registration request...")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Network error during registration: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Registration response status code: \(httpResponse.statusCode)")
                print("Registration response headers: \(httpResponse.allHeaderFields)")
            }
            
            guard let data = data else {
                print("No data received from registration request")
                completion(.failure(NSError(domain: "AuthService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            print("Received data from registration request: \(data.count) bytes")
            
            if let responseString = String(data: data, encoding: .utf8) {
                print("Registration response raw data: \(responseString)")
            }
            
            do {
                let authResponse = try JSONDecoder().decode(UserModel.self, from: data)
                print("Registration successful: User ID: \(authResponse.userId), Name: \(authResponse.name)")
                completion(.success(authResponse))
            } catch {
                print("Error decoding registration response: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }.resume()
    }
    
    func login(email: String, password: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
        print("Starting login for email: \(email)")
        
        guard let url = URL(string: "\(baseURL)/login") else {
            print("Error: Invalid URL for login")
            return
        }
        
        print("Login URL: \(url.absoluteString)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["email": email, "password": password]
        print("Login request body (email only): \(["email": email])")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
            print("Request body serialized successfully")
        } catch {
            print("Error serializing request body: \(error.localizedDescription)")
            completion(.failure(error))
            return
        }
        
        print("Sending login request...")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Network error during login: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Login response status code: \(httpResponse.statusCode)")
                print("Login response headers: \(httpResponse.allHeaderFields)")
            }
            
            guard let data = data else {
                print("No data received from login request")
                completion(.failure(NSError(domain: "AuthService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            print("Received data from login request: \(data.count) bytes")
            
            if let responseString = String(data: data, encoding: .utf8) {
                print("Login response raw data: \(responseString)")
            }
            
            do {
                let authResponse = try JSONDecoder().decode(UserModel.self, from: data)
                print("Login successful: User ID: \(authResponse.userId), Name: \(authResponse.name)")
                completion(.success(authResponse))
            } catch {
                print("Error decoding login response: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }.resume()
    }
    
}
