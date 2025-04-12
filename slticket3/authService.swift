//  AuthService.swift
import Foundation
import Combine

@MainActor
final class AuthService: ObservableObject {
    @Published private(set) var accessToken: String?
    
    static let shared = AuthService()
    private init() {}
    
    private let baseURL = ""
    private let session: URLSession = .shared
    
    func login(email: String, password: String) async throws {
        print("🟢 AuthService.login called with", email)
        
        guard !email.isEmpty, !password.isEmpty else {
            print("🔴 invalidForm")
            throw AuthError.invalidForm
        }
        
        #if DEBUG
        if let url = Bundle.main.url(forResource: "mock_login_success",
                                     withExtension: "json") {
            let data = try Data(contentsOf: url)
            let response = try JSONDecoder().decode(LoginResponse.self, from: data)
            try persist(token: response.accessToken, source: "local‑mock")
            return
        } else {
            print("⚠️  mock file NOT found, falling through to network")
        }
        #endif
        
        let url = URL(string: baseURL + "/api/auth/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(LoginRequest(email: email,
                                                                 password: password))
        
        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse else {
            print("🔴 unknown response")
            throw AuthError.unknown
        }
        
        switch http.statusCode {
        case 200:
            let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
            try persist(token: loginResponse.accessToken, source: "network")
        case 401:
            print("401 invalid credentials")
            throw AuthError.invalidCredentials
        default:
            print("server code", http.statusCode)
            throw AuthError.serverError(code: http.statusCode)
        }
    }
    
    func debugPrintStoredToken() {
        if let t = TokenManager.shared.getToken() {
            print("🔐 Keychain token prefix:", t.prefix(20), "…")
        } else {
            print("🔐 No token found in Keychain")
        }
    }
    
    // future ticket
    func refreshToken() async throws {
        throw AuthError.notImplemented
    }
    
    private func persist(token: String, source: String) throws {
        try TokenManager.shared.save(token: token)
        accessToken = token
        print("\(source) success – token saved")
        
        if let stored = TokenManager.shared.getToken() {
            print("Stored token (first 20):", stored.prefix(20), "…")
        } else {
            print("Failed to read token back from Keychain")
        }
    }
}
