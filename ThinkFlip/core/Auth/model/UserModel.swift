//
//  AuthResponse.swift
//  ThinkFlip
//
//  Created by Pranav on 23/03/25.
//

import Foundation

struct UserModel: Codable {
    let message: String
    let success: Bool
    let jwtToken: String
    let email: String
    let name: String
    
    // If your code elsewhere expects "token" and "userId", you can add computed properties
    var token: String { return jwtToken }
    var userId: String { return email } // Or you could use another field if appropriate
}
