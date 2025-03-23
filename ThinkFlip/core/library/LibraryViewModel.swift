import Foundation

class LibraryViewModel: ObservableObject {
    @Published var history: [ScannedDoc] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var needsRelogin = false
    
    private let apiURL = "https://thinkflip-backend.onrender.com/history/user-history"
    
    func fetchHistory() {
        guard let url = URL(string: apiURL) else {
            print("❌ Invalid URL")
            return
        }
        
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            print("❌ No auth token found, user might not be logged in")
            errorMessage = "Please log in to view your history."
            needsRelogin = true
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(token)", forHTTPHeaderField: "Authorization")
        
        isLoading = true
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
            }
            
            if let error = error {
                print("❌ Network error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to load history."
                }
                return
            }
            
            guard let data = data else {
                print("❌ No data received from API")
                DispatchQueue.main.async {
                    self.errorMessage = "No history found."
                }
                return
            }
            
            // Print the raw response for debugging
            if let responseString = String(data: data, encoding: .utf8) {
                print("📊 API Response: \(responseString)")
                
                // Check for authentication error
                if responseString.contains("Unauthorized") || responseString.contains("expired") {
                    DispatchQueue.main.async {
                        self.errorMessage = "Your session has expired. Please log in again."
                        self.needsRelogin = true
                    }
                    return
                }
            }
            
            // Create a decoder with flexible date strategy
            let decoder = JSONDecoder()
            
            // Try multiple date decoding strategies
            do {
                // First try to parse as an error message
                if let errorResponse = try? decoder.decode(ErrorResponse.self, from: data),
                   !errorResponse.message.isEmpty {
                    DispatchQueue.main.async {
                        self.errorMessage = errorResponse.message
                        if errorResponse.message.contains("Unauthorized") ||
                            errorResponse.message.contains("token") ||
                            errorResponse.message.contains("expired") {
                            self.needsRelogin = true
                        }
                    }
                    return
                }
                
                // Try first with MongoDB date format ($date field)
                decoder.dateDecodingStrategy = .custom { decoder in
                    let container = try decoder.singleValueContainer()
                    
                    // Try to decode as a MongoDB date object first
                    if let dateDict = try? container.decode([String: String].self),
                       let dateString = dateDict["$date"] {
                        if let date = ISO8601DateFormatter().date(from: dateString) {
                            return date
                        }
                        
                        // Try with a more flexible formatter as fallback
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                        formatter.timeZone = TimeZone(abbreviation: "UTC")
                        if let date = formatter.date(from: dateString) {
                            return date
                        }
                        
                        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date: \(dateString)")
                    }
                    
                    // If not a MongoDB date object, try as a direct string
                    let dateString = try container.decode(String.self)
                    
                    // Try ISO8601 first
                    if let date = ISO8601DateFormatter().date(from: dateString) {
                        return date
                    }
                    
                    // Try with a more flexible formatter as fallback
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                    formatter.timeZone = TimeZone(abbreviation: "UTC")
                    if let date = formatter.date(from: dateString) {
                        return date
                    }
                    
                    throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date: \(dateString)")
                }
                
                // Try various response formats
                if let historyResponse = try? decoder.decode(ScannedHistoryResponseWrapper.self, from: data) {
                    DispatchQueue.main.async {
                        self.history = historyResponse.history
                    }
                } else if let docs = try? decoder.decode([ScannedDoc].self, from: data) {
                    DispatchQueue.main.async {
                        self.history = docs
                    }
                } else {
                    // If all else fails, try to extract and decode each document individually
                    do {
                        let json = try JSONSerialization.jsonObject(with: data)
                        
                        if let responseDict = json as? [String: Any],
                            let historyArray = responseDict["history"] as? [[String: Any]] {
                            
                            // Print the first document for debugging
                            if let firstDoc = historyArray.first {
                                print("🔍 First document structure: \(firstDoc)")
                            }
                            
                            // Process each document manually
                            var docs: [ScannedDoc] = []
                            for docDict in historyArray {
                                if let id = docDict["_id"] as? String,
                                   let user = docDict["user"] as? String,
                                   let content = docDict["content"] as? String {
                                    
                                    // Handle date in various formats
                                    var docDate = Date()
                                    
                                    if let dateString = docDict["date"] as? String {
                                        let formatter = DateFormatter()
                                        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                                        formatter.timeZone = TimeZone(abbreviation: "UTC")
                                        docDate = formatter.date(from: dateString) ?? Date()
                                    } else if let dateDict = docDict["date"] as? [String: Any],
                                              let dateString = dateDict["$date"] as? String {
                                        let formatter = DateFormatter()
                                        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                                        formatter.timeZone = TimeZone(abbreviation: "UTC")
                                        docDate = formatter.date(from: dateString) ?? Date()
                                    }
                                    
                                    let document = ScannedDoc(id: id, user: user, content: content, date: docDate)
                                    docs.append(document)
                                }
                            }
                            
                            DispatchQueue.main.async {
                                self.history = docs
                            }
                        } else {
                            throw DecodingError.dataCorrupted(DecodingError.Context(
                                codingPath: [],
                                debugDescription: "Expected dictionary with 'history' array"
                            ))
                        }
                    } catch {
                        throw error
                    }
                }
            } catch {
                print("❌ Final decoding error: \(error)")
                
                if let decodingError = error as? DecodingError {
                    print("📝 Decoding error details: \(decodingError)")
                }
                
                DispatchQueue.main.async {
                    self.errorMessage = "Error parsing history data."
                }
            }
        }.resume()
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "authToken")
        needsRelogin = false
        errorMessage = "Please log in to view your history."
    }
}
