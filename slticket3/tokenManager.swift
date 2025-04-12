//  TokenManager.swift
import Foundation
import KeychainAccess

struct TokenManager {
    static let shared = TokenManager()
    
    private let keychain = Keychain(service: "somefintechstuff.com")
    private let tokenKey = "access_token"
    
    func save(token: String) throws {
        try keychain.set(token, key: tokenKey)
    }
    
    func getToken() -> String? {
        keychain[tokenKey]
    }
    
    func clearToken() throws {
        try keychain.remove(tokenKey)
    }
}
