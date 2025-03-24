import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var errorMessage: String?
    @Published var user: UserModel?
    
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
        authService.register(username: username, email: email, password: password) { result in
            DispatchQueue.main.async {
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
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func login(email: String, password: String) {
        authService.login(email: email, password: password) { result in
            DispatchQueue.main.async {
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
                    self.errorMessage = error.localizedDescription
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
