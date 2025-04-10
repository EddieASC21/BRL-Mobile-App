import Foundation

struct AuthResponse: Codable {
    let access_token: String
}

// possible errors for authentication
enum AuthError: Error {
    case invalidResponse
    case fileNotFound
}

//  handles login "request" by reading from mock_login json.
class AuthService {
    static let shared = AuthService()
    
    func login(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        let loginData = [
            "email": email,
            "password": password
        ]
        guard let requestBody = try? JSONSerialization.data(withJSONObject: loginData, options: []),
              let requestBodyString = String(data: requestBody, encoding: .utf8)
        else {
            completion(.failure(AuthError.invalidResponse))
            return
        }
        
        print("POST /api/auth/login with body: \(requestBodyString)")
        
        // simulate network delay
        DispatchQueue.global().async {
            sleep(1)
            
            guard let fileURL = Bundle.main.url(forResource: "mock_login", withExtension: "json") else {
                DispatchQueue.main.async {
                    completion(.failure(AuthError.fileNotFound))
                }
                return
            }
            
            do {
                let data = try Data(contentsOf: fileURL)
                let authResponse = try JSONDecoder().decode(AuthResponse.self, from: data)
                // return token on main thread
                DispatchQueue.main.async {
                    completion(.success(authResponse.access_token))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
