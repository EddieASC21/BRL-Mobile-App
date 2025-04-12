//  Models.swift
import Foundation

struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct LoginResponse: Codable {
    let accessToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}

enum AuthError: LocalizedError {
    case invalidForm
    case invalidCredentials
    case serverError(code: Int)
    case unknown
    case notImplemented
    
    var errorDescription: String? {
        switch self {
        case .invalidForm:
            return "Please enter a valid email and password."
        case .invalidCredentials:
            return "The email or password you entered is incorrect."
        case .serverError(let code):
            return "Server returned an error (code: \(code))."
        case .unknown:
            return "An unknown error occurred. Please try again."
        case .notImplemented:
            return "This feature is not yet implemented."
        }
    }
}
