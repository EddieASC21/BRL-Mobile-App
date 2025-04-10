import Foundation

struct AuthToken: Codable {
    let access_token: String
}

enum AuthError: Error, LocalizedError {
    case invalidCredentials
    case decodingError
    case networkError(Error)
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "invalid email or password."
        case .decodingError:
            return "failed to decode server response."
        case .networkError(let err):
            return err.localizedDescription
        case .unknownError:
            return "an unknown error occurred."
        }
    }
}

final class AuthService {
    static let shared = AuthService()
    private init() {}
    
    //using mock server
    var useMock = true
    
    func login(email: String, password: String) async throws -> AuthToken {
        if useMock {
            return try await mockLogin()
        } else {
            return try await liveLogin(email: email, password: password)
        }
    }

    // MARK: - Mock
    private func mockLogin() async throws -> AuthToken {
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 second delay
        
        guard let url = Bundle.main.url(forResource: "mock_login_response", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let token = try? JSONDecoder().decode(AuthToken.self, from: data) else {
            throw AuthError.decodingError
        }
        
        return token
    }

    //real backend
    private func liveLogin(email: String, password: String) async throws -> AuthToken {
        guard let url = URL(string: "link of the backend") else {
            throw AuthError.unknownError
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = ["email": email, "password": password]
        request.httpBody = try JSONEncoder().encode(body)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
                throw AuthError.invalidCredentials
            }
            
            return try JSONDecoder().decode(AuthToken.self, from: data)
        } catch {
            throw AuthError.networkError(error)
        }
    }

    extension AuthService {
    func refreshToken() async throws {
        // TODO: Implement token refresh using refresh token
        // Example call: /api/auth/refresh with stored refresh token
        throw NSError(domain: "RefreshNotImplemented", code: -1)
    }
}
}
