import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var errorMessage: String?
    @Published var user: UserModel?
    @Published var isLoading = false
    
    private let authService = AuthService.shared
    
    static var authToken: String? {  // 🔥 Static JWT Token
        UserDefaults.standard.string(forKey: "authToken")
    }
    
    init() {
        checkSession()
    }
    
    func checkSession() {
        if let _ = UserDefaults.standard.string(forKey: "authToken"),
           let savedUserData = UserDefaults.standard.data(forKey: "currentUser"),
           let savedUser = try? JSONDecoder().decode(UserModel.self, from: savedUserData) {
            isAuthenticated = true
            user = savedUser
        } else {
            isAuthenticated = false
            user = nil
        }
    }
    
    func register(username: String, email: String, password: String) {
        isLoading = true
        errorMessage = nil
        
        authService.register(username: username, email: email, password: password) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                case .success(let authResponse):
                    self.isAuthenticated = true
                    self.user = authResponse
                    
                    // Store token and user data in UserDefaults
                    UserDefaults.standard.set(authResponse.token, forKey: "authToken")
                    if let encodedUser = try? JSONEncoder().encode(authResponse) {
                        UserDefaults.standard.set(encodedUser, forKey: "currentUser")
                    }
                    
                case .failure(let error):
                    // Handle specific error types
                    if let nsError = error as NSError? {
                        // Handle network errors
                        if nsError.domain == NSURLErrorDomain {
                            self.errorMessage = "Network error: Please check your connection"
                        } else if let httpResponse = nsError.userInfo["HTTPResponseStatusCode"] as? Int {
                            // Handle HTTP error codes
                            switch httpResponse {
                            case 401:
                                self.errorMessage = "Invalid email or password"
                            case 404:
                                self.errorMessage = "Account not found"
                            case 409:
                                self.errorMessage = "Email already in use"
                            case 500:
                                self.errorMessage = "Server error. Please try again later"
                            default:
                                self.errorMessage = "Registration failed: \(nsError.localizedDescription)"
                            }
                        } else {
                            self.errorMessage = "Registration failed: \(nsError.localizedDescription)"
                        }
                    } else {
                        // General error handling
                        self.errorMessage = "Registration failed: \(error.localizedDescription)"
                    }
                }
            }
        }
    }
    
    func login(email: String, password: String) {
        isLoading = true
        errorMessage = nil
        
        // Validate inputs
        if email.isEmpty || password.isEmpty {
            errorMessage = "Email and password cannot be empty"
            isLoading = false
            return
        }
        
        authService.login(email: email, password: password) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                case .success(let authResponse):
                    self.isAuthenticated = true
                    self.user = authResponse
                    
                    // Store token and user data in UserDefaults
                    UserDefaults.standard.set(authResponse.token, forKey: "authToken")
                    if let encodedUser = try? JSONEncoder().encode(authResponse) {
                        UserDefaults.standard.set(encodedUser, forKey: "currentUser")
                    }
                    
                case .failure(let error):
                    // Parse server error response if available
                    if let decodingError = error as? DecodingError {
                        // This likely means the server returned an error message in a different format
                        self.errorMessage = "Invalid email or password"
                    } else if let nsError = error as NSError? {
                        // Handle network errors
                        if nsError.domain == NSURLErrorDomain {
                            self.errorMessage = "Network error: Please check your connection"
                        } else if let httpResponse = nsError.userInfo["HTTPResponseStatusCode"] as? Int {
                            // Handle HTTP error codes
                            switch httpResponse {
                            case 401:
                                self.errorMessage = "Invalid email or password"
                            case 404:
                                self.errorMessage = "Account not found"
                            case 500:
                                self.errorMessage = "Server error. Please try again later"
                            default:
                                self.errorMessage = "Login failed: \(nsError.localizedDescription)"
                            }
                        } else {
                            // Check if error message contains password-related keywords
                            let errorDesc = nsError.localizedDescription.lowercased()
                            if errorDesc.contains("password") || errorDesc.contains("credential") {
                                self.errorMessage = "Invalid email or password"
                            } else {
                                self.errorMessage = "Login failed: \(nsError.localizedDescription)"
                            }
                        }
                    } else {
                        // General error handling
                        let errorDesc = error.localizedDescription.lowercased()
                        if errorDesc.contains("password") || errorDesc.contains("credential") ||
                            errorDesc.contains("unauthorized") || errorDesc.contains("401") {
                            self.errorMessage = "Invalid email or password"
                        } else {
                            self.errorMessage = "Login failed: \(error.localizedDescription)"
                        }
                    }
                }
            }
        }
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "authToken")
        UserDefaults.standard.removeObject(forKey: "currentUser")
        isAuthenticated = false
        user = nil
    }
}
