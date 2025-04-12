//  JWTDecode.swift
import Foundation
import JWTDecode   

struct JWTDecoder {
    static func expirationDate(from token: String) -> Date? {
        guard let jwt = try? decode(jwt: token) else { return nil }
        return jwt.expiresAt
    }
    
    static func isExpired(_ token: String) -> Bool {
        guard let exp = expirationDate(from: token) else { return true }
        return Date() >= exp
    }
}
