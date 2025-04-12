import Foundation

enum DemoError: LocalizedError {
    case missingToken
    case http(code: Int)
    case badResponse
}

@MainActor
struct DemoAPIService {
    static func ping() async throws {
        guard let token = TokenManager.shared.getToken() else {
            print("🔴 no token in Keychain")
            throw DemoError.missingToken
        }
        
        let url = URL(string: "http://localhost:8080/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        print("📡 Sending GET with header:", request.value(forHTTPHeaderField: "Authorization")!)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse else { throw DemoError.badResponse }
        
        guard http.statusCode == 200 else {
            print("🔴 server replied", http.statusCode)
            throw DemoError.http(code: http.statusCode)
        }
        print("200 OK – token accepted")
    }
}
